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
        if #available(iOSApplicationExtension 16.0, *) {
            return WidgetBundleBuilder.buildBlock(MyCardWidget(), OpenAppLockScreenWidget(), QRCodeWidget())
        } else {
            return WidgetBundleBuilder.buildBlock(MyCardWidget(), QRCodeWidget())
        }
    }
}
