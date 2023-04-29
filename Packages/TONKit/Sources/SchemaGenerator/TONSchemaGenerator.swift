//
//  Created by Vladislav Kiriukhin on 09.04.2023.
//

import Foundation

@main
final class TONSchemaGenerator {
    private static var schemaLink: String {
        "https://raw.githubusercontent.com/ton-blockchain/ton/3b3c25b654ade3fcea1546d7b91454673038ed4e/tl/generate/scheme/tonlib_api.tl"
    }

    private static var outputURL: URL {
        URL(
            fileURLWithPath: "../Schema/TONSchemaGenerated.swift",
            relativeTo: URL(fileURLWithPath: #file).deletingLastPathComponent()
        )
    }

    static func main() async throws -> Void {
        let schemaData = try await URLSession.shared.data(from: URL(string: schemaLink)!).0
        let schemaContent = String(data: schemaData, encoding: .utf8) ?? ""

        let generatedContent = try generate(from: schemaContent.split(separator: "\n")
            .map(String.init))
            .reduce(into: "") { partialResult, line in
                partialResult += line.description + "\n"
            }

        try generatedContent.write(to: outputURL, atomically: true, encoding: .utf8)
    }

    private static func generate(from schemaLines: [String]) throws -> [Line] {
        var mode: Mode = .constructors

        var generated: [Line] = []
        generated.append("import Foundation")
        generated.append("")

        var constructors: [String] = []
        var functions: [String] = []

        for line in schemaLines {
            if line.hasPrefix("//") {
                continue
            }

            if line.hasPrefix("---functions---") {
                mode = .functions
                continue
            }

            if mode == .constructors {
                constructors.append(line)
            } else {
                functions.append(line)
            }
        }

        var enumObjects = [String: [Token]]()

        for ctor in constructors {
            generated.append(contentsOf: generateConstructor(from: ctor, enumObjects: &enumObjects))
        }

        for (enumName, enumCases) in enumObjects {
            generated.append("")
            generated.append("public enum \(enumName): TDEnum {")

            for cs in enumCases where !cs.string.isEmpty {
                generated.append("case \(cs.generateCaseName())(\(cs.generateClassName()))", indent: 1)
            }

            generated.append("")
            generated.append("public init(from decoder: Decoder) throws {", indent: 1)
            generated.append("let container = try decoder.container(keyedBy: TLTypedCodingKey.self)", indent: 2)
            generated.append("let type = try container.decode(String.self, forKey: ._type)", indent: 2)
            generated.append("")
            generated.append("switch type {", indent: 2)

            for cs in enumCases where !cs.string.isEmpty {
                generated.append("case \(cs.generateClassName())._type:", indent: 2)
                generated.append("self = .\(cs.generateCaseName())(try \(cs.generateClassName())(from: decoder))", indent: 3)
            }
            generated.append("default: throw TLTypedUnknownTypeError()", indent: 2)

            generated.append("}", indent: 2)
            generated.append("}", indent: 1)

            generated.append("")
            generated.append("public func encode(to encoder: Encoder) throws {", indent: 1)
            generated.append("var container = encoder.container(keyedBy: TLTypedCodingKey.self)", indent: 2)
            generated.append("")
            generated.append("switch self {", indent: 2)

            for cs in enumCases where !cs.string.isEmpty {
                generated.append("case let .\(cs.generateCaseName())(value):", indent: 2)
                generated.append("try container.encode(type(of: value)._type, forKey: ._type)", indent: 3)
                generated.append("try value.encode(to: encoder)", indent: 3)
            }

            generated.append("}", indent: 2)
            generated.append("}", indent: 1)

            generated.append("}")
        }

        for fn in functions {
            generated.append(contentsOf: generateFunction(from: fn))
        }

        return generated
    }

    private static func generateFunction(from line: String) -> [Line] {
        let line = line.replacingOccurrences(of: ";", with: "")
        let parts = line.split(separator: "=").map(String.init)

        let returnClassName = Token(string: parts[1].trim())

        var lines: [Line] = []

        let args = Token(string: parts[0]).parseArguments()
        lines.append(contentsOf: generateFnObject(returnClassName: returnClassName, args: args))

        return lines
    }

    private static func generateConstructor(
        from line: String,
        enumObjects: inout [String: [Token]]
    ) -> [Line] {
        let line = line.replacingOccurrences(of: ";", with: "")
        let parts = line.split(separator: "=").map(String.init)

        let className = Token(string: parts[1].trim())

        let (shouldSkip, tryAsPrimitive) = className.generatePrimitiveTypealias()
        if shouldSkip {
            guard let tryAsPrimitive else { return [] }

            return [
                .init(string: "public typealias \(className) = \(tryAsPrimitive)", indent: 0)
            ]
        }

        var lines: [Line] = []

        let args = Token(string: parts[0]).parseArguments()
        let (objectLines, additionalCase) = generateObject(className: className, args: args)

        if let additionalCase {
            enumObjects[additionalCase.superType, default: []].append(additionalCase.caseType)
        }
        lines.append(contentsOf: objectLines)

        return lines
    }

    private static func generateObject(
        className: Token,
        args: [Token]
    ) -> (lines: [Line], (superType: String, caseType: Token)?) {
        var lines: [Line] = []

        let ctorName = args[0]

        lines.append("")
        lines.append("public struct \(ctorName.generateClassName()): TLObject {")
        lines.append("public static var _type: String { \"\(ctorName)\" }", indent: 1)

        if !args.contains(where: { $0.string.contains(":#") }) {
            let parsedArgs = args.dropFirst().map { $0.generateArgument() }

            lines.append("")

            // Props
            for (argName, argType) in parsedArgs {
                lines.append("public let \(argName): \(argType)", indent: 1)
            }

            if parsedArgs.count > 0 {
                lines.append("")
            }

            // Init
            lines.append("public init(\(parsedArgs.count == 0 ? ") { }" : "")", indent: 1)

            if parsedArgs.count > 0 {
                for (idx, (argName, argType)) in parsedArgs.enumerated() {
                    let isLast = idx == parsedArgs.count - 1
                    lines.append("\(argName): \(argType)\(isLast ? "" : ",")", indent: 2)
                }

                lines.append(") {", indent: 1)

                for (argName, _) in parsedArgs {
                    lines.append("self.\(argName) = \(argName)", indent: 2)
                }

                lines.append("}", indent: 1)
            }

            if parsedArgs.count > 0 {
                // CodingKeys
                lines.append("")
                lines.append("public enum _Key: String, CodingKey {", indent: 1)
                lines.append("case _type = \"@type\"", indent: 2)
                for (argName, _) in parsedArgs {
                    lines.append("case \(argName) = \"\(argName.snakeCased)\"", indent: 2)
                }
                lines.append("}", indent: 1)

                // init
                lines.append("")
                lines.append("public init(from decoder: Decoder) throws {", indent: 1)
                lines.append("let container = try decoder.container(keyedBy: _Key.self)", indent: 2)
                for (argName, argType) in parsedArgs {
                    lines.append("self.\(argName) = try container.decode(\(argType).self, forKey: .\(argName))", indent: 2)
                }
                lines.append("}", indent: 1)

                // encode
                lines.append("")
                lines.append("public func encode(to encoder: Encoder) throws {", indent: 1)
                lines.append("var container = encoder.container(keyedBy: _Key.self)", indent: 2)
                lines.append("try container.encode(Self._type, forKey: ._type)", indent: 2)
                for (argName, _) in parsedArgs {
                    lines.append("try container.encode(self.\(argName), forKey: .\(argName))", indent: 2)
                }
                lines.append("}", indent: 1)
            }
        }

        lines.append("}")

        return (
            lines,
            {
                if className.generateClassName() != ctorName.generateClassName() {
                    return (className.generateClassName(), ctorName)
                }
                return nil
            }()
        )
    }

    private static func generateFnObject(
        returnClassName: Token,
        args: [Token]
    ) -> [Line] {
        var lines: [Line] = []

        let fnName = args[0]
        let needGenericFunction = args.dropFirst().contains(where: { $0.generateArgument().1 == "Function" })
        let needGenericObject = returnClassName.generateClassName() == "Object"

        let genericFunctionToken = [
            needGenericFunction ? "Function: TLFunction" : nil,
            needGenericObject ? "Object: TLType" : nil
        ].compactMap { $0 }.joined(separator: ", ")
        let genericFunction = genericFunctionToken.isEmpty ? "" : "<\(genericFunctionToken)>"

        lines.append("")
        lines.append("public struct \(fnName.generateClassName())\(genericFunction): TLFunction {")
        lines.append("public typealias ReturnType = \(returnClassName.generateClassName())", indent: 1)
        lines.append("")
        lines.append("public static var _type: String { \"\(fnName)\" }", indent: 1)
        lines.append("")

        if !args.contains(where: { $0.string.contains(":#") }) {
            let parsedArgs = args.dropFirst().map { $0.generateArgument() }

            for (argName, argType) in parsedArgs {
                lines.append("public let \(argName): \(argType)", indent: 1)
            }

            if parsedArgs.count > 0 {
                lines.append("")
            }

            lines.append("public init(\(parsedArgs.count == 0 ? ") { }" : "")", indent: 1)

            if parsedArgs.count > 0 {
                for (idx, (argName, argType)) in parsedArgs.enumerated() {
                    let isLast = idx == parsedArgs.count - 1
                    lines.append("\(argName): \(argType)\(isLast ? "" : ",")", indent: 2)
                }

                lines.append(") {", indent: 1)

                for (argName, _) in parsedArgs {
                    lines.append("self.\(argName) = \(argName)", indent: 2)
                }

                lines.append("}", indent: 1)
            }

            // CodingKeys
            lines.append("")
            lines.append("public enum _Key: String, CodingKey {", indent: 1)
            lines.append("case _type = \"@type\"", indent: 2)
            for (argName, _) in parsedArgs {
                lines.append("case \(argName) = \"\(argName.snakeCased)\"", indent: 2)
            }
            lines.append("}", indent: 1)

            // init
            if parsedArgs.count > 0 {
                lines.append("")
                lines.append("public init(from decoder: Decoder) throws {", indent: 1)
                lines.append("let container = try decoder.container(keyedBy: _Key.self)", indent: 2)
                for (argName, argType) in parsedArgs {
                    lines.append("self.\(argName) = try container.decode(\(argType).self, forKey: .\(argName))", indent: 2)
                }
                lines.append("}", indent: 1)
            }

            // encode
            lines.append("")
            lines.append("public func encode(to encoder: Encoder) throws {", indent: 1)
            lines.append("var container = encoder.container(keyedBy: _Key.self)", indent: 2)
            lines.append("try container.encode(Self._type, forKey: ._type)", indent: 2)
            for (argName, _) in parsedArgs {
                lines.append("try container.encode(self.\(argName), forKey: .\(argName))", indent: 2)
            }
            lines.append("}", indent: 1)
        }

        lines.append("}")

        return lines
    }
}

enum Mode {
    case constructors
    case functions
}

struct Line: CustomStringConvertible {
    let string: String
    let indent: Int

    var description: String {
        String(repeating: " ", count: indent * 4) + string
    }
}

extension Array where Element == Line {
    mutating func append(_ string: String, indent: Int = 0) {
        append(Line(string: string, indent: indent))
    }
}

struct Token: CustomStringConvertible {
    let string: String

    var description: String { string }

    func parseArguments() -> [Token] {
        let string = string.replacingOccurrences(of: "vector ", with: "vector<")
        return string.split(separator: " ").map(String.init).map { $0.trim() }.map(Token.init(string:))
    }

    func generateArgument() -> (String, String) {
        let parts = string.split(separator: ":").map(String.init)

        if parts.count != 2 {
            assertionFailure("Invalid arg: \(string)")
            return ("", "")
        }

        var sanitizedType = String(
            parts[1]
                .dropFirst(parts[1].first == "(" ? 1 : 0)
                .dropLast(parts[1].last == ")" ? 1 : 0)
        )

        if sanitizedType.contains("vector<") {
            let vectorElementType = sanitizedType.dropFirst(7).dropLast(sanitizedType.last == ">" ? 1 : 0)
            sanitizedType = "[\(Token(string: String(vectorElementType)).generateClassName())]"
        }

        var name = parts[0].lowerCamelCased
        if ["init"].contains(name) {
            name = "`\(name)`"
        }

        let type = Token(string: sanitizedType).generateClassName()

        return (name, type)
    }

    func generateClassName() -> String {
        let parts = string.split(separator: ".").map(String.init).map { $0.firstLetterUppercased }
        let name = parts.joined(separator: "")
        return name
    }

    func generateCaseName() -> String {
        generateClassName().firstLetterLowercased
    }

    func generatePrimitiveTypealias() -> (Bool, String?) {
        switch string {
        case "Double":
            return (true, nil)
        case "String":
            return (true, nil)
        case "Int32":
            return (true, nil)
        case "Int53":
            return (true, "Swift.Int64")
        case "Int64":
            return (true, "TLInt64")
        case "Int256":
            return (true, "Int64") // temporary
        case "Bytes":
            return (true, "Foundation.Data")
        case "SecureString":
            return (true, "Swift.String")
        case "SecureBytes":
            return (true, "Foundation.Data")
        case "Object":
            return (true, "TLObject")
        case "Function":
            return (true, "TLFunction")
        case "Bool":
            return (true, nil)
        case string where string.starts(with: "Vector"):
            return (true, nil)
        default:
            return (false, nil)
        }
    }
}

extension String {
    var firstLetterLowercased: String {
        prefix(1).lowercased() + String(dropFirst())
    }

    var firstLetterUppercased: String {
        prefix(1).uppercased() + String(dropFirst())
    }

    var lowerCamelCased: String {
        let parts = split(separator: "_").map(String.init)
        return ([parts[0].firstLetterLowercased] + Array(parts.dropFirst().map { $0.firstLetterUppercased })).joined()
    }

    func trim() -> String {
        self.replacingOccurrences(of: " ", with: "")
    }
}

extension String {
    var snakeCased: String {
        let string = self.replacingOccurrences(of: "`", with: "")
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let normalPattern = "([a-z0-9])([A-Z])"
        return string.processCamelCaseRegex(pattern: acronymPattern)?
            .processCamelCaseRegex(pattern: normalPattern)?.lowercased() ?? string.lowercased()
    }

    private func processCamelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
