import Foundation

public protocol Graph {
    var accessPoints: Set<AccessPoint> { get }
    var apsConnections: Set<Connection<AccessPoint, AccessPoint>> { get }
    var hostConnections: Set<Connection<Host, AccessPoint>> { get }
    mutating func generate()
    
    func createUUID() -> String
}

public extension Graph {
    func createUUID() -> String { return UUID().uuidString }
}
