//
//  Condition.swift
//  SGen
//
//  Created by Daniele Pizziconi on 06/04/2019.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation

extension Condition: Generatable {
    
    /// Generates the code for this right hand side value.
    func generate(_ nested: Bool = false) -> String {
        var expressions = [String]()
        for expression in self.expressions {
            
            var string = ""
            switch expression.expression.0 {
            case .fixedWidth, .fixedHeight:
                let size = "UIScreen.main.fixedCoordinateSpace.bounds.size"
                string += expression.expression.0  == .fixedWidth ? "\(size).width " : "\(size).height "
            case .width, .height:
                let size = "UIScreen.main.bounds.size"
                string += expression.expression.0  == .width ? "\(size).width " : "\(size).height "
            case .horizontal:
                string += "(traitCollection?.horizontalSizeClass ?? UIUserInterfaceSizeClass.unspecified) "
            case .vertical:
                string += "(traitCollection?.verticalSizeClass ?? UIUserInterfaceSizeClass.unspecified) "
            case .idiom:
                string += "UIDevice.current.userInterfaceIdiom "
            case .contentSize:
                string += "Application.preferredContentSizeCategory() "
            case .unspecified:
                string += "true "
            }
            
            switch expression.expression.1 {
            case .equal: string += "== "
            case .notEqual: string += "!= "
            case .greaterThan: string += "> "
            case .greaterThanOrequal: string += ">= "
            case .lessThan: string += "< "
            case .lessThanOrequal: string += "<= "
            case .unspecified: string += ""
            }
            
            switch expression.expression.2 {
            case .fixedWidth, .fixedHeight:
                let size = "UIScreen.main.fixedCoordinateSpace.bounds.size"
                string += expression.expression.2  == .fixedWidth ? "\(size).width " : "\(size).height "
            case .width, .height:
                let size = "UIScreen.main.bounds.size"
                string += expression.expression.2  == .width ? "\(size).width " : "\(size).height "
            case .constant:
                string += "\(expression.expression.3)"
            case .compact:
                string += "UIUserInterfaceSizeClass.compact"
            case .regular:
                string += "UIUserInterfaceSizeClass.regular"
            case .pad:
                string += "UIUserInterfaceIdiom.pad"
            case .phone:
                string += "UIUserInterfaceIdiom.phone"
            case .contentSizeExtraSmall:
                string += ".extraSmall"
            case .contentSizeSmall:
                string += ".small"
            case .contentSizeMedium:
                string += ".medium"
            case .contentSizeLarge:
                string += ".large"
            case .contentSizeExtraLarge:
                string += ".extraLarge"
            case .contentSizeExtraExtraLarge:
                string += ".extraExtraLarge"
            case .contentSizeExtraExtraExtraLarge:
                string += ".extraExtraExtraLarge"
            case .contentSizeAccessibilityMedium:
                string += ".accessibilityMedium"
            case .contentSizeAccessibilityLarge:
                string += ".accessibilityLarge"
            case .contentSizeAccessibilityExtraLarge:
                string += ".accessibilityExtraLarge"
            case .contentSizeAccessibilityExtraExtraLarge:
                string +=  ".accessibilityExtraExtraLarge"
            case .contentSizeAccessibilityExtraExtraExtraLarge:
                string += ".accessibilityExtraExtraExtraLarge"
            case .unspecified: string += ""
            }
            expressions.append(string)
        }
        return expressions.joined(separator: " && ")
    }
}

enum ConditionError: Error {
    case malformedCondition(error: String)
    case malformedRhsValue(error: String)
}

func ==<T:Parsable>(lhs: T, rhs: T) -> Bool {
    return lhs.rawString == rhs.rawString
}

func hash<T:Parsable>(_ item: T) -> Int {
    return item.rawString.hashValue;
}

protocol Parsable: Equatable {
    var rawString: String { get }
    init(rawString: String) throws
}

struct Condition: Hashable, Parsable {
    
    struct ExpressionToken {
        
        enum Default: String {
            case `default` = "default"
            case external = "?"
        }
        
        enum Lhs: String {
            case horizontal = "horizontal"
            case vertical = "vertical"
            case fixedWidth = "fixedWidth"
            case fixedHeight = "fixedHeight"
            case width = "width"
            case height = "height"
            case idiom = "idiom"
            case contentSize = "category"
            case unspecified = "unspecified"
        }
        
        enum Operator: String {
            case equal = "="
            case notEqual = "≠"
            case lessThan = "<"
            case lessThanOrequal = "≤"
            case greaterThan = ">"
            case greaterThanOrequal = "≥"
            case unspecified = "unspecified"
            
            static func all() -> [Operator] {
                return [equal, notEqual, lessThan, lessThanOrequal, greaterThan, greaterThanOrequal]
            }
            
            static func allRaw() -> [String] {
                return [equal.rawValue,
                        notEqual.rawValue,
                        lessThan.rawValue,
                        lessThanOrequal.rawValue,
                        greaterThan.rawValue,
                        greaterThanOrequal.rawValue]
            }
            
            static func characterSet() -> CharacterSet {
                return CharacterSet(charactersIn: self.allRaw().joined(separator: ""))
            }
            
            static func operatorContainedInString(_ string: String) -> Operator {
                for opr in self.all() {
                    if string.range(of: opr.rawValue) != nil {
                        return opr
                    }
                }
                return unspecified
            }
            
            func isEqual<T:Equatable>(_ lhs: T, rhs: T) -> Bool {
                switch self {
                case .equal: return lhs == rhs
                case .notEqual: return lhs != rhs
                default: return false
                }
            }
            
            func compare<T:Comparable>(_ lhs: T, rhs: T) -> Bool {
                switch self {
                case .equal: return lhs == rhs
                case .notEqual: return lhs != rhs
                case .lessThan: return lhs < rhs
                case .lessThanOrequal: return lhs <= rhs
                case .greaterThan: return lhs > rhs
                case .greaterThanOrequal: return lhs >= rhs
                default: return false
                }
            }
        }
        
        enum Rhs: String {
            case regular = "regular"
            case compact = "compact"
            case fixedWidth = "fixedWidth"
            case fixedHeight = "fixedHeight"
            case width = "width"
            case height = "height"
            case pad = "pad"
            case phone = "phone"
            case constant = "_"
            case contentSizeExtraSmall = "xs"
            case contentSizeSmall = "s"
            case contentSizeMedium = "m"
            case contentSizeLarge = "l"
            case contentSizeExtraLarge = "xl"
            case contentSizeExtraExtraLarge = "xxl"
            case contentSizeExtraExtraExtraLarge = "xxxl"
            case contentSizeAccessibilityMedium = "am"
            case contentSizeAccessibilityLarge = "al"
            case contentSizeAccessibilityExtraLarge = "axl"
            case contentSizeAccessibilityExtraExtraLarge = "axxl"
            case contentSizeAccessibilityExtraExtraExtraLarge = "axxxl"
            case unspecified = "unspecified"
        }
    }
    
    struct Expression: Hashable, Parsable {
        
        /// @see Parsable.
        let rawString: String
        
        /// Wether this expression is always true or not.
        fileprivate let tautology: Bool
        
        /// The actual parsed expression.
        fileprivate let expression: (Condition.ExpressionToken.Lhs,
        Condition.ExpressionToken.Operator,
        Condition.ExpressionToken.Rhs,
        Float)
        
        /// Hashable compliancy.
        func hash(into hasher: inout Hasher) {
            hasher.combine(rawString)
        }
        
        init(rawString: String) throws {
            self.rawString = normalizeExpressionString(rawString)
            // Check for default expression.
            if self.rawString.range(of: Condition.ExpressionToken.Default.default.rawValue) != nil {
                self.expression = (.unspecified, .unspecified, .unspecified, 0)
                self.tautology = true
                // Expression.
            } else {
                self.tautology = false
                var terms = self.rawString.components(separatedBy:
                    Condition.ExpressionToken.Operator.characterSet())
                let opr = Condition.ExpressionToken.Operator.operatorContainedInString(self.rawString)
                
                if terms.count != 2 || opr == Condition.ExpressionToken.Operator.unspecified {
                    throw ConditionError.malformedCondition(error: "No valid operator found in the string")
                }
                terms = terms.map({
                    return $0.trimmingCharacters(in: CharacterSet.whitespaces)
                })
                
                let constant: Float
                let hasConstant: Bool
                if let c = Float(terms[1]) {
                    constant = c
                    hasConstant = true
                } else {
                    constant = Float.nan
                    hasConstant = false
                }
                guard let lhs = Condition.ExpressionToken.Lhs(rawValue: terms[0]),
                    let rhs = hasConstant
                        ? Condition.ExpressionToken.Rhs.constant
                        : Condition.ExpressionToken.Rhs(rawValue: terms[1]) else {
                            throw ConditionError.malformedCondition(error: "Terms of the condition not valid.")
                }
                self.expression = (lhs, opr, rhs, constant)
            }
        }
    }
    
    /// @see Parsable.
    let rawString: String
    var expressions: [Expression] = [Expression]()
    
    /// Hashable compliancy.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawString)
    }
    
    init(rawString: String) throws {
        self.rawString = normalizeExpressionString(rawString)
        let components = self.rawString.components(separatedBy: "and")
        for exprString in components {
            try expressions.append(Expression(rawString: exprString))
        }
    }
    
    func isDefault() -> Bool {
        return rawString.contains("default")
    }
}

private func normalizeExpressionString(_ string: String, forceLowerCase: Bool = true) -> String {
    var ps = string.trimmingCharacters(in: CharacterSet.whitespaces)
    ps = (ps as NSString).replacingOccurrences(of: "\"", with: "")
    
    if forceLowerCase {
        ps = ps.lowercased()
    }
    ps = ps.replacingOccurrences(of: "\"",
                                 with: "")
    ps = ps.replacingOccurrences(of: "'",
                                 with: "")
    ps = ps.replacingOccurrences(of: "!=",
                                 with: Condition.ExpressionToken.Operator.notEqual.rawValue)
    ps = ps.replacingOccurrences(of: "<=",
                                 with: Condition.ExpressionToken.Operator.lessThanOrequal.rawValue)
    ps = ps.replacingOccurrences(of: ">=",
                                 with: Condition.ExpressionToken.Operator.greaterThanOrequal.rawValue)
    ps = ps.replacingOccurrences(of: "==",
                                 with: Condition.ExpressionToken.Operator.equal.rawValue)
    ps = ps.trimmingCharacters(in: CharacterSet.whitespaces)
    return ps
}
