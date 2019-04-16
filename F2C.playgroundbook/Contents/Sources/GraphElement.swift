import UIKit

public protocol GraphElement: Hashable {
    var id: String { get set }
    var name: String { get set }
    var color: UIColor { get set }
    var image: UIImage { get set }
    var mutatedImage: UIImage { get set }
}

public extension GraphElement {
    var hashValue: Int {
        return id.hashValue ^ name.hashValue ^ color.hashValue
    }
}
