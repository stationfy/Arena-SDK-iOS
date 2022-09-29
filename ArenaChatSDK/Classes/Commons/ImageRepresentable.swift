import UIKit

protocol ImageRepresentable: RawRepresentable {
    var image: UIImage { get }
}

extension ImageRepresentable where RawValue == String {
    var image: UIImage {
        UIImage(named: rawValue, in: Bundle(identifier: "org.cocoapods.ArenaChatSDK"), compatibleWith: nil) ?? UIImage()
    }
}
