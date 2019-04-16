import UIKit

public extension UIView {
    public var image: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            if let context = UIGraphicsGetCurrentContext() {
                layer.render(in: context)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                return image
            }
            return nil
        }
    }
}
