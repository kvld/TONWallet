//
//  Created by Vladislav Kiriukhin on 14.05.2023.
//

import UIKit
import AVFoundation
import SwiftUI
import Components

public final class QRScannerController: UIViewController {
    private lazy var captureSession = AVCaptureSession()
    private lazy var output = AVCaptureMetadataOutput()
    private var videoLayer: AVCaptureVideoPreviewLayer?

    public var onSuccessfulScan: ((String) -> Void)?
    public var onCloseTap: (() -> Void)?
    public var onSettingsOpenTap: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupVideo()
    }

    private func setupVideo() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            setupOverlayNoAccess()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)

            captureSession.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoLayer = previewLayer
            videoLayer?.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)

            setupOverlay()

            DispatchQueue.global(qos: .userInteractive).async { [captureSession] in
                captureSession.startRunning()
            }
        } catch {
            setupOverlayNoAccess()
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        videoLayer?.frame = view.layer.bounds

        let cutoutWidth: CGFloat = min(view.bounds.width, view.bounds.height) / 1.5

        let roi = CGRect(
            x: (view.bounds.width - cutoutWidth) / 2.0,
            y: (view.bounds.height - cutoutWidth) / 2.0 - 44,
            width: cutoutWidth,
            height: cutoutWidth
        )
        .insetBy(dx: -20, dy: -20)

        output.rectOfInterest = videoLayer?.metadataOutputRectConverted(fromLayerRect: roi)
            ?? .init(x: 0, y: 0, width: 1, height: 1)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInteractive).async { [captureSession] in
                captureSession.startRunning()
            }
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    // MARK: - Private

    private func toggleFlashlight() {
        guard let captureDevice = AVCaptureDevice.default(for: .video), captureDevice.hasTorch else {
            return
        }

        do {
            try captureDevice.lockForConfiguration()
            captureDevice.torchMode = captureDevice.torchMode == .on ? .off : .on
            captureDevice.unlockForConfiguration()
        } catch {
            captureDevice.unlockForConfiguration()
        }
    }

    private func setupOverlayNoAccess() {
        let overlayView = _UIHostingView(
            rootView: OverlayNoAccessView { [weak self] in
                self?.onSettingsOpenTap?()
            }
        )

        view.addSubview(overlayView)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupOverlay() {
        let overlayView = _UIHostingView(
            rootView: OverlayView { [weak self] in
                self?.toggleFlashlight()
            } onCloseTap: { [weak self] in
                self?.onCloseTap?()
            }
        )

        view.addSubview(overlayView)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }

        if object.type == .qr, let value = object.stringValue {
            onSuccessfulScan?(value)
        }
    }
}

private struct OverlayNoAccessView: View {
    let onSettingsOpenTap: () -> Void

    var body: some View {
        VStack {
            Spacer()

            Text("No Camera Access")
                .fontConfiguration(.title1)
                .foregroundColor(.white)
                .padding(.top, -44)
                .padding(.bottom, 12)
                .padding(.horizontal, 48)

            Text("TON Wallet doesn’t have access to the camera. Please enable camera access to scan QR codes.")
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .fontConfiguration(.body.regular)
                .padding(.bottom, 100)
                .padding(.horizontal, 48)

            Button("Open Settings") {
                onSettingsOpenTap()
            }
            .buttonStyle(.action())
            .padding(.horizontal, 48)

            Spacer()
        }
    }
}

private struct OverlayView: View {
    @State private var isFlashlightEnabled = false

    let onFlashlightToggle: () -> Void
    let onCloseTap: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let cutoutWidth: CGFloat = min(geometry.size.width, geometry.size.height) / 1.5

            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text("Scan QR Code")
                        .foregroundColor(.white)
                        .fontConfiguration(.title1)
                        .padding(.bottom, 44)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black)
                        .frame(width: cutoutWidth, height: cutoutWidth, alignment: .center)
                        .blendMode(.destinationOut)
                        .overlay {
                            Path { path in
                                path.addPath(
                                    createCornersPath(
                                        left: 0,
                                        top: 0,
                                        right: cutoutWidth,
                                        bottom: cutoutWidth,
                                        cornerRadius: 6,
                                        cornerLength: 26
                                    )
                                )
                            }
                            .stroke(Color.white, lineWidth: 3.5)
                            .frame(width: cutoutWidth, height: cutoutWidth, alignment: .center)
                            .aspectRatio(1, contentMode: .fit)
                        }

                    HStack {
                        Spacer()

                        Blur(style: isFlashlightEnabled ? .dark : .light)
                            .frame(width: 72, height: 72)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(36)
                            .overlay {
                                Image("flashlight").resizable()
                                    .foregroundColor(isFlashlightEnabled ? .white : .black)
                            }
                            .onTapWithFeedback {
                                isFlashlightEnabled.toggle()
                                onFlashlightToggle()
                            }

                        Spacer()
                    }
                    .padding(.top, 60)
                }
            }
            .compositingGroup()
            .overlay {
                VStack {
                    HStack {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .fontConfiguration(.body.regular)
                            .onTapWithFeedback(action: onCloseTap)
                            .padding(.leading, 16)
                            .frame(height: 56, alignment: .center)

                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    private func createCornersPath(
        left: CGFloat,
        top: CGFloat,
        right: CGFloat,
        bottom: CGFloat,
        cornerRadius: CGFloat,
        cornerLength: CGFloat
    ) -> Path {
        var path = Path()

        // top left
        path.move(to: CGPoint(x: left, y: (top + cornerRadius / 2.0)))
        path.addArc(
            center: CGPoint(x: (left + cornerRadius / 2.0), y: (top + cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 180.0),
            endAngle: Angle(degrees: 270.0),
            clockwise: false
        )

        path.move(to: CGPoint(x: left + (cornerRadius / 2.0), y: top))
        path.addLine(to: CGPoint(x: left + (cornerRadius / 2.0) + cornerLength, y: top))

        path.move(to: CGPoint(x: left, y: top + (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: left, y: top + (cornerRadius / 2.0) + cornerLength))

        // top right
        path.move(to: CGPoint(x: right - cornerRadius / 2.0, y: top))
        path.addArc(
            center: CGPoint(x: (right - cornerRadius / 2.0), y: (top + cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 270.0),
            endAngle: Angle(degrees: 360.0),
            clockwise: false
        )

        path.move(to: CGPoint(x: right - (cornerRadius / 2.0), y: top))
        path.addLine(to: CGPoint(x: right - (cornerRadius / 2.0) - cornerLength, y: top))

        path.move(to: CGPoint(x: right, y: top + (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: right, y: top + (cornerRadius / 2.0) + cornerLength))

        // bottom left
        path.move(to: CGPoint(x: left + cornerRadius / 2.0, y: bottom))
        path.addArc(
            center: CGPoint(x: (left + cornerRadius / 2.0), y: (bottom - cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 90.0),
            endAngle: Angle(degrees: 180.0),
            clockwise: false
        )

        path.move(to: CGPoint(x: left + (cornerRadius / 2.0), y: bottom))
        path.addLine(to: CGPoint(x: left + (cornerRadius / 2.0) + cornerLength, y: bottom))

        path.move(to: CGPoint(x: left, y: bottom - (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: left, y: bottom - (cornerRadius / 2.0) - cornerLength))

        // bottom right
        path.move(to: CGPoint(x: right, y: bottom - cornerRadius / 2.0))
        path.addArc(
            center: CGPoint(x: (right - cornerRadius / 2.0), y: (bottom - cornerRadius / 2.0)),
            radius: cornerRadius / 2.0,
            startAngle: Angle(degrees: 0.0),
            endAngle: Angle(degrees: 90.0),
            clockwise: false
        )

        path.move(to: CGPoint(x: right - (cornerRadius / 2.0), y: bottom))
        path.addLine(to: CGPoint(x: right - (cornerRadius / 2.0) - cornerLength, y: bottom))

        path.move(to: CGPoint(x: right, y: bottom - (cornerRadius / 2.0)))
        path.addLine(to: CGPoint(x: right, y: bottom - (cornerRadius / 2.0) - cornerLength))

        return path
    }
}

private struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
