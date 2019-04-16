import UIKit

public final class SlidingView: UIViewController {
    
    fileprivate enum Side {
        case left
        case right
    }
    
    public var left: UIView
    public var right: UIView
    private(set) var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderChangedValue(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("❌", for: .normal)
        button.backgroundColor = UIColor(hexString: "262938")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeWasPressed(_:)), for: .touchUpInside)
        return button
    }()
    public private(set) var dismissBlock: (SlidingView) -> Void = { _ in }
    
    // MARK: - Life cycle
    public init(left: UIView, right: UIView, dismissBlock: @escaping (SlidingView) -> Void) {
        self.left = left
        self.right = right
        self.dismissBlock = dismissBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.left = UIView()
        self.right = UIView()
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(left)
        view.addSubview(right)
        
        NSLayoutConstraint.activate([
            left.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            left.topAnchor.constraint(equalTo: view.topAnchor),
            left.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            left.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            right.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            right.topAnchor.constraint(equalTo: view.topAnchor),
            right.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            right.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
        view.addSubview(slider)
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            slider.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(closeButton)
        let buttonCons: [Constraint] = [
            .leading(constant: 20),
            .top(constant: 20),
            .height(constant: 50),
            .width(constant: 50)
        ]
        NSLayoutConstraint.activate(buttonCons.map{$0.generateNSLayoutContraint(view, closeButton)})
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _createMask(to: left, side: .left, width: left.frame.width/2)
        _createMask(to: right, side: .right, width: right.frame.width/2)
    }
}

private extension SlidingView {
    func _createMask(to view: UIView, side: Side, width: CGFloat) {
        var vRect = view.frame
        vRect.size.width = width
        if side == .right { vRect.origin.x = view.frame.width/2 }
        let path = UIBezierPath(rect: vRect)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
//        maskLayer.fillRule = .evenOdd
        view.layer.mask = maskLayer
    }
    
    @objc func sliderChangedValue(_ sender: UISlider) {
        let value = sender.value
        var leftFrame = left.frame
        if let mask = left.layer.mask as? CAShapeLayer {
            leftFrame.size.width = CGFloat(value) * view.frame.width / 100
            let path = UIBezierPath(rect: leftFrame)
            mask.path = path.cgPath
        }
        
        if let mask = right.layer.mask as? CAShapeLayer {
            var rightFrame = right.frame
            rightFrame.origin.x = leftFrame.width
            let path2 = UIBezierPath(rect: rightFrame)
            mask.path = path2.cgPath
        }
    }
    
    @objc private func closeWasPressed(_ sender: UIButton) {
        dismissBlock(self)
    }
}

