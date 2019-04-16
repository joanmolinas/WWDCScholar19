import UIKit

public struct BasicScenarioGraph: Graph {
    private(set) public var accessPoints: Set<AccessPoint> = []
    private(set) public var apsConnections: Set<Connection<AccessPoint, AccessPoint>> = []
    private(set) public var hostConnections: Set<Connection<Host, AccessPoint>> = []
    
    public init() { }
    
    public mutating func generate() {
        // Fog layer 1
        
        var layer1AccessPoint = AccessPoint(id: createUUID(), name: "Layer 1 access point", color: UIColor(hexString: "E57373"), image: UIImage(named: "Building1")!, mutatedImage: UIImage(named: "Server")!)
        let layer1Host1 = Host(id: createUUID(), name: "L1H1", image: UIImage(named: "CCTV")!, mutatedImage: UIImage(named: "CPU")!)
        let layer1Host2 = Host(id: createUUID(), name: "L2H2", image: UIImage(named: "Semaphore")!, mutatedImage: UIImage(named: "CPU")!)
        let layer1Host3 = Host(id: createUUID(), name: "L3H3", image: UIImage(named: "Scotter")!, mutatedImage: UIImage(named: "CPU")!)
        layer1AccessPoint.insert(host: layer1Host1)
        layer1AccessPoint.insert(host: layer1Host2)
        layer1AccessPoint.insert(host: layer1Host3)
        // Fog layer 2
        var layer2AccessPoint = AccessPoint(id: createUUID(), name: "Layer 2 access point", color: UIColor(hexString: "E57373"), image: UIImage(named: "Home")!, mutatedImage: UIImage(named: "Server")!)
        let layer2Host1 = Host(id: createUUID(), name: "L2H1", image: UIImage(named: "Car")!, mutatedImage: UIImage(named: "CPU")!)
        let layer2Host2 = Host(id: createUUID(), name: "L2H2", image: UIImage(named: "MotionCamera")!, mutatedImage: UIImage(named: "CPU")!)
        layer2AccessPoint.insert(host: layer2Host1)
        layer2AccessPoint.insert(host: layer2Host2)
        // Internet
        let internetAccessPoint = AccessPoint(id: createUUID(), name: "Internet access point", color: UIColor(hexString: "FFF176"), image: UIImage(named: "Internet")!, mutatedImage: UIImage(named: "Server")!)
        // Cloud
        let cloudAccessPoint = AccessPoint(id: createUUID(), name: "Cloud access point", color: UIColor(hexString: "80CBC4"), image: UIImage(named: "Cloud")!, mutatedImage: UIImage(named: "CloudServer")!)
        
        accessPoints.insert(layer1AccessPoint)
        accessPoints.insert(layer2AccessPoint)
        accessPoints.insert(internetAccessPoint)
        accessPoints.insert(cloudAccessPoint)
        
        
        let l1H1AP1 = Connection(id: createUUID(), name: "l1H1AP1", from: layer1Host1, to: layer1AccessPoint, technology: .ethernet)
        let l1H2AP1 = Connection(id: createUUID(), name: "l1H2AP1", from: layer1Host2, to: layer1AccessPoint, technology: .ethernet)
        let l1H3AP1 = Connection(id: createUUID(), name: "l1H3AP1", color: UIColor.black, from: layer1Host3, to: layer1AccessPoint, technology: Technology.wifi)
        
        let l2H1AP1 = Connection(id: createUUID(), name: "l2H1AP1", from: layer2Host1, to: layer2AccessPoint, technology: .wifi)
        let l2H2AP1 = Connection(id: createUUID(), name: "l2H2AP1", from: layer2Host2, to: layer2AccessPoint, technology: .wifi)

        let layer1Layer2Connection = Connection(id: createUUID(), name: "L1L2Connection", from: layer1AccessPoint, to: layer2AccessPoint, technology: .ethernet)
        let layer1InternetConnection = Connection(id: createUUID(), name: "L1InternetConnection", from: layer1AccessPoint, to: internetAccessPoint, technology: .ethernet)
        let layer2InternetConnection = Connection(id: createUUID(), name: "L2InternetConnection", from: layer2AccessPoint, to: internetAccessPoint, technology: .ethernet)
        let internetCloudConnection = Connection(id: createUUID(), name: "InternetCloudConnection", color: .black, from: internetAccessPoint, to: cloudAccessPoint, technology: .fiber)
        apsConnections.insert(layer1Layer2Connection)
        apsConnections.insert(layer1InternetConnection)
        apsConnections.insert(layer2InternetConnection)
        apsConnections.insert(internetCloudConnection)
        hostConnections.insert(l1H1AP1)
        hostConnections.insert(l1H2AP1)
        hostConnections.insert(l1H3AP1)
        hostConnections.insert(l2H1AP1)
        hostConnections.insert(l2H2AP1)
        
    }
}
