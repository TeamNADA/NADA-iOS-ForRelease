// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

internal enum Colors {
    internal static let black = ColorAsset(name: "black")
    internal static let delete = ColorAsset(name: "delete")
    internal static let errorBackground = ColorAsset(name: "errorBackground")
    internal static let errorText = ColorAsset(name: "errorText")
    internal static let group1 = ColorAsset(name: "group1")
    internal static let group2 = ColorAsset(name: "group2")
    internal static let group3 = ColorAsset(name: "group3")
    internal static let group4 = ColorAsset(name: "group4")
    internal static let hint = ColorAsset(name: "hint")
    internal static let inputBlack = ColorAsset(name: "inputBlack")
    internal static let listSelectedBlack = ColorAsset(name: "listSelectedBlack")
    internal static let mainBlue = ColorAsset(name: "mainBlue")
    internal static let matchButton = ColorAsset(name: "matchButton")
    internal static let modalBackground = ColorAsset(name: "modalBackground")
    internal static let modalButton = ColorAsset(name: "modalButton")
    internal static let step = ColorAsset(name: "step")
    internal static let unselectedOption = ColorAsset(name: "unselectedOption")
    internal static let white = ColorAsset(name: "white")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
