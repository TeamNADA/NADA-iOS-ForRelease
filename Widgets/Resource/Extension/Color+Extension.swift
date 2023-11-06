//
//  Color+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/02/04.
//

import SwiftUI

extension Color {
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0)
        case .dark:
            return Color(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 49.0 / 255.0)
        @unknown default:
            return Color(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0)
        }
    }
    
    static func primaryColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .light {
            return Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0)
        } else {
            return Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
        }
    }
    
    static func userNameColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0)
        case .dark:
            return Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
        @unknown default:
            return Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0)
        }
    }
    
    static func widgetBackgrounColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .light {
            return Color(red: 241.0 / 255.0, green: 243.0 / 255.0, blue: 245.0 / 255.0)
        } else {
            return Color(red: 43.0 / 255.0, green: 45.0 / 255.0, blue: 49.0 / 255.0)
        }
    }
}
