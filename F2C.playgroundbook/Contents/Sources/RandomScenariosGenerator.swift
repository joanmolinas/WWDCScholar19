import UIKit

public struct RandomScenariosGenerator: Graph {
    
    static let edges: [String] = ["VideoCamera", "Car", "Drone", "CCTV", "Semaphore", "Detector", "MotionCamera", "Scotter"]
    static let nodes: [String] = ["Building1", "Building2", "Home"]
    static let edgesMutated: [String] = ["BlueMotherboard", "GreenMotherboard", "CPU", "CPUBlue"]
    static let connections: [Technology] = [.ethernet, .wifi, .fiber]
    
    private(set) public var accessPoints: Set<AccessPoint> = []
    private(set) public var apsConnections: Set<Connection<AccessPoint, AccessPoint>> = []
    private(set) public var hostConnections: Set<Connection<Host, AccessPoint>> = []
    public var numberOfEdges = 3
    public var numberOfComputersPerEdge = 3
    
    public init() { }
    
    public mutating func generate() {
        // Base nodes (Cloud and internet)
        // Internet
        let internetAccessPoint = AccessPoint(id: createUUID(), name: "Internet access point", color: UIColor(hexString: "FFF176"), image: UIImage(named: "Internet")!, mutatedImage: UIImage(named: "Server")!)
        // Cloud
        accessPoints.insert(internetAccessPoint)
        
        (0..<numberOfEdges).forEach { _ in
            var ap = randomNode()
            (0..<numberOfComputersPerEdge).forEach{_ in
                let h = randomHost()
                let connection = randomConnection(from: h, to: ap)
                ap.insert(host: h)
                hostConnections.insert(connection)
            }
            accessPoints.insert(ap)
        }
       
        let aps = Array(accessPoints)
        for i in 0..<aps.count {
            let from = aps[i]
            for j in i..<aps.count {
                guard i != j else { continue }
                let to = aps[j]
                let con = randomConnection(from: from, to: to)
                apsConnections.insert(con)
            }
        }
        let cloudAccessPoint = AccessPoint(id: createUUID(), name: "Cloud access point", color: UIColor(hexString: "80CBC4"), image: UIImage(named: "Cloud")!, mutatedImage: UIImage(named: "CloudServer")!)
        accessPoints.insert(cloudAccessPoint)
        let internetCloudConnection = Connection(id: createUUID(), name: "InternetCloudConnection", color: .black, from: internetAccessPoint, to: cloudAccessPoint, technology: .fiber)
        apsConnections.insert(internetCloudConnection)
    }
    
    func randomHost() -> Host {
        let uuid = createUUID()
        let image = RandomScenariosGenerator.edges.randomElement() ?? "CCTV"
        let mutated = RandomScenariosGenerator.edgesMutated.randomElement() ?? "BlueMotherboard"
        return Host(id: uuid,
                    name: uuid,
                    image: UIImage(named: image)!,
                    mutatedImage: UIImage(named: mutated)!)
    }
    func randomNode() -> AccessPoint {
        let uuid = createUUID()
        let image = RandomScenariosGenerator.nodes.randomElement() ?? "Home"
        let mutated = "Server"
        return AccessPoint(
            id: uuid, name: uuid,
            color: UIColor(hexString: "E57373"),
            image: UIImage(named: image)!,
            mutatedImage: UIImage(named: mutated)!)
    }
    
    func randomConnection<T: GraphElement, U: GraphElement>(from: T, to: U) -> Connection<T, U> {
        let uuid = createUUID()
        let tech = RandomScenariosGenerator.connections.randomElement() ?? .ethernet
        return Connection(id: uuid,
                   name: uuid,
                   from: from,
                   to: to,
                   technology: tech)
    }
}
