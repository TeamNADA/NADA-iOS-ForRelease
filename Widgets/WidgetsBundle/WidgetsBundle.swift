//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by kimhyungyu on 2023/02/04.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        MyCardWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            OpenAppLockScreenWidget()
        }
        QRCodeWidget()
    }
}
