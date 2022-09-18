import UIKit

public protocol ImageRepresentable: RawRepresentable {
    var image: UIImage { get }
}

public extension ImageRepresentable where RawValue == String {
    var image: UIImage {
        UIImage(named: rawValue, in: Bundle(identifier: "org.cocoapods.ArenaChatSDK"), compatibleWith: nil) ?? UIImage()
    }
}
