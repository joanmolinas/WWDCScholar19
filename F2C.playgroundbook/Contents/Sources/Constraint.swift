import UIKit

public enum Constraint {
    case leading(constant: CGFloat)
    case top(constant: CGFloat)
    case trailing(constant: CGFloat)
    case bottom(constant: CGFloat)
    case width(constant: CGFloat)
    case height(constant: CGFloat)
    case centerX(constant: CGFloat)
    case centerY(constant: CGFloat)
}

public extension Constraint {
    func generateNSLayoutContraint(_ parent: UIView, _ child: UIView) -> NSLayoutConstraint {
        switch self {
        case .leading(let constant): return child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: constant)
        case .top(let constant): return child.topAnchor.constraint(equalTo: parent.topAnchor, constant: constant)
        case .trailing(let constant): return child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: constant)
        case .bottom(let constant): return child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: constant)
        case .width(let constant): return child.widthAnchor.constraint(equalToConstant: constant)
        case .height(let constant): return child.heightAnchor.constraint(equalToConstant: constant)
        case .centerX(let constant): return child.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: constant)
        case .centerY(let constant): return child.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: constant)
        }
    }
}
