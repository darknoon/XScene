import SnapshotTesting
import SceneKit
import Foundation
@testable import XScene

enum _SCNMaterialPropertyContents {
    case color(PlatformColor)
    case image(NSImage)
    case unknown
}

extension Snapshotting where Value == _SCNMaterialPropertyContents, Format == String {
    static let description = Snapshotting<String, String>.description.pullback{
        (contents: _SCNMaterialPropertyContents) -> String in
        switch contents {
        case let .color(color):
            return String(describing: color)
        case let .image(image):
            return String(describing: image)
        default:
            return "Can't describe \(String(describing: contents))"
        }
    }
}

extension Snapshotting where Value == SCNMaterialProperty, Format == String {
    static let description = Snapshotting<_SCNMaterialPropertyContents, String>.description.pullback{
        (property: SCNMaterialProperty) -> _SCNMaterialPropertyContents in
        let contents = property.contents
        if let color = contents as? PlatformColor {
            return .color(color)
        }
        if let image = contents as? NSImage {
            return .image(image)
        }
        return .unknown
    }
}
