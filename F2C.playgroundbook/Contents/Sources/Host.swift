import UIKit

public struct Host: GraphElement {
    public var id: String
    public var name: String
    public var color: UIColor
    public var image: UIImage
    public var mutatedImage: UIImage
    
    public init(id: String,
                name: String,
                color: UIColor = UIColor(hexString: "64B5F6"),
                image: UIImage,
                mutatedImage: UIImage) {
        self.id = id
        self.name = name
        self.color = color
        self.image = image
        self.mutatedImage = mutatedImage
    }
}
