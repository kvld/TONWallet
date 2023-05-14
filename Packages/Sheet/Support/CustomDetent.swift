//
//  Created by Vladislav Kiriukhin on 13.05.2023.
//

import UIKit

@available(iOS 15.0, *)
extension UISheetPresentationController.Detent {
    public static func _custom(height: CGFloat, identifier: String? = nil) -> UISheetPresentationController.Detent {
        // + (UISheetPresentationControllerDetent *)_detentWithIdentifier:(NSString *)identifier constant:(CGFloat)constant;
        let id = NSString(string: identifier ?? "detent_\(height)")
        let selector = NSSelectorFromString("_detentWithIdentifier:constant:")
        return UISheetPresentationController.Detent.perform(selector, with: id, with: height)
            .takeUnretainedValue() as! UISheetPresentationController.Detent
    }
}
