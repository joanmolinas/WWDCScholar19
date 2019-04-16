import UIKit

public struct AccessPoint: GraphElement {
    public var id: String
    public var name: String
    public var color: UIColor
    public var image: UIImage
    public var mutatedImage: UIImage
    public private(set) var hosts: Set<Host>
    
    public init(id: String,
                name: String,
                color: UIColor = UIColor(hexString: "F06292"),
                image: UIImage,
                mutatedImage: UIImage,
                hosts: Set<Host> = []) {
        self.id = id
        self.name = name
        self.color = color
        self.hosts = hosts
        self.image = image
        self.mutatedImage = mutatedImage
    }
    
    mutating func insert(host: Host) {
        hosts.insert(host)
    }
}
