import UIKit

public protocol Copiable {
    init(_ element: Self)
}

public protocol SkeletonElement: Copiable {
    func mutate()
}

// The lines
protocol SkeletonVeinable: SkeletonElement {}

// The objects
protocol SkeletonPieceable: SkeletonElement {
    var piece: UIImage { get }
    var isMutated: Bool { get set }
}

