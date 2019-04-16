import UIKit

public enum Technology: String {
    case ethernet = "ethernet"
    case wifi = "wifi"
    case fiber = "fiber"
}

public struct Connection<T: GraphElement, U: GraphElement>: GraphElement {
    
    public var id: String
    public var name: String
    public var color: UIColor
    public var image: UIImage
    public var mutatedImage: UIImage
    public var from: T
    public var to: U
    public var technology: Technology
    
    init(id: String,
         name: String,
         color: UIColor = .gray,
         image: UIImage = UIImage(),
         mutatedImage: UIImage = UIImage(),
         from: T,
         to: U,
         technology: Technology) {
        self.id = id
        self.name = name
        self.color = color
        self.from = from
        self.to = to
        self.image = image
        self.technology = technology
        self.mutatedImage = mutatedImage
    }
}

public func ==<T: GraphElement, U: GraphElement>(lhs: Connection<T, U>, rhs: Connection<T, U>) -> Bool {
    return lhs.id == rhs.id
}


