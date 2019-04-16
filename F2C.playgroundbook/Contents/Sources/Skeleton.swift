import UIKit

public struct Skeleton {
    
    // MARK: - Properties
    public private(set) var body: UIView
    public private(set) var skeleton: UIView
    
    public init(body: UIView, skeletonColor: UIColor = .black) {
        self.body = body
        self.skeleton = UIView(frame: body.frame)
        let img = UIImageView(image: UIImage(named: "background"))
        img.frame = self.skeleton.frame
        self.skeleton.insertSubview(img, at: 0)
    }
    
    // Use it when you want to set up constraints between subviews object
    public func add<T: SkeletonElement>(_ view: T, constraints: [Constraint]) where T: UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        body.addSubview(view)
        let bodyConstraints = constraints.map{$0.generateNSLayoutContraint(body, view)}
        NSLayoutConstraint.activate(bodyConstraints)
        
        let copy = T(view)
        copy.mutate()
        copy.translatesAutoresizingMaskIntoConstraints = false
        skeleton.addSubview(copy)
        let skeletonConstraints = constraints.map{$0.generateNSLayoutContraint(skeleton, copy)}
        NSLayoutConstraint.activate(skeletonConstraints)
    }
}
