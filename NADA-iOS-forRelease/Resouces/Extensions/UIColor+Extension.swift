//
//  UIColor+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/07.
//

import Foundation
import UIKit

extension UIColor {
    
    @nonobjc class var mainColorNadaMain: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 112.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var mainColorButtonText: UIColor {
        return UIColor(red: 131.0 / 255.0, green: 136.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var primary: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
                } else {
                    return UIColor(white: 1.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
        }
    }
    
    @nonobjc class var textBox: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        }
    }
    
    @nonobjc class var quaternary: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(red: 168.0 / 255.0, green: 172.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 102.0 / 255.0, green: 108.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 168.0 / 255.0, green: 172.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
        }
    }
    
    @nonobjc class var tertiary: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(red: 102.0 / 255.0, green: 108.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 168.0 / 255.0, green: 172.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 102.0 / 255.0, green: 108.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
        }
    }
    
    @nonobjc class var secondary: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 49.0 / 255.0, alpha: 1.0)
        }
    }
    
    @nonobjc class var button: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(red: 233.0 / 255.0, green: 236.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 53.0 / 255.0, green: 56.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 233.0 / 255.0, green: 236.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
        }
    }

    @nonobjc class var stateColorError: UIColor {
        return UIColor(red: 243.0 / 255.0, green: 66.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var background: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(white: 1.0, alpha: 1.0)
                } else {
                    return UIColor(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(white: 1.0, alpha: 1.0)
        }
    }
    
    @nonobjc class var bottomDimmedBackground: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return UIColor(white: 0.0, alpha: 0.4)
                } else {
                    return UIColor(white: 0.0, alpha: 0.8)
                }
            }
        } else {
            return UIColor(white: 0.0, alpha: 0.4)
        }
    }
    
    @nonobjc class var harmonyRed: UIColor {
      return UIColor(red: 239.0 / 255.0, green: 115.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var harmonyPurple: UIColor {
      return UIColor(red: 95.0 / 255.0, green: 111.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var harmonyGreen: UIColor {
      return UIColor(red: 110.0 / 255.0, green: 240.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var harmonyOrange: UIColor {
      return UIColor(red: 248.0 / 255.0, green: 141.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var harmonyYellow: UIColor {
      return UIColor(red: 253.0 / 255.0, green: 209.0 / 255.0, blue: 0.0, alpha: 1.0)
    }

}
