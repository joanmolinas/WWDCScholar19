import UIKit

public struct SkeletonParticle: Particle, SkeletonElement {
    public var identifier: String
    public var velocity: CGPoint
    public var position: CGPoint
    public var fixed: Bool
    public let view: Unmanaged<UIView>
    
    public var hashValue: Int {
        return view.takeUnretainedValue().hashValue
    }
    
    public init(view: UIView, identifier: String) {
        self.view = .passUnretained(view)
        self.velocity = .zero
        self.position = view.center
        self.fixed = false
        self.identifier = identifier
    }
    
    public init(_ element: SkeletonParticle) {
        self.init(view: element.view.takeUnretainedValue(), identifier: element.identifier)
    }
    
    public func tick() {
        view.takeUnretainedValue().center = position
    }
    
    public func mutate() {
        let v = view.takeUnretainedValue()
        v.subviews.filter{$0 is SkeletonPiece}.forEach{
            let v = ($0 as! SkeletonPiece)
            v.mutate()
            v.isMutated.toggle()
        }
    }
}

public func ==(lhs: SkeletonParticle, rhs: SkeletonParticle) -> Bool {
    return lhs.view.toOpaque() == rhs.view.toOpaque()
}
