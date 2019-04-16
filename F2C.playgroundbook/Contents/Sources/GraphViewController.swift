import UIKit

public final class GraphViewController: UIViewController {
    
    // MARK: - Properties
    public var isRadiographyButtonHidden = true {
        didSet { radiographyButton.isHidden = isRadiographyButtonHidden }
    }
    
    public var isLegendHidden = true {
        didSet { legendStackView.isHidden = isLegendHidden }
    }
    
    public var isRandomHidden = true {
        didSet { randomButton.isHidden = isRandomHidden }
    }
    public var randomAvailable = false {
        didSet { isRandomHidden = !randomAvailable }
    }
    
    public private(set) var graph: Graph!
    private let center: Center<SkeletonParticle> = Center(.zero)
    private let manyParticle: ManyParticle<SkeletonParticle> = ManyParticle()
    private let links: Links<SkeletonParticle> = Links()
    private var accessPointsCreated: Set<SkeletonParticle> = []
    private var legend: [Int: [String: UIColor]] = [
        1: ["Fog layer 1": UIColor(hexString: "64B5F6")],
        2: ["Fog layer 2": UIColor(hexString: "E57373")],
        3: ["Internet": UIColor(hexString: "FFF176")],
        4: ["Cloud": UIColor(hexString: "80CBC4")],
        5: ["Wifi": .orange],
        6: ["Ethernet": .red],
        7: ["Fiber": .blue]
    ]
    private var linkLayers: [Int: CAShapeLayer] = [:]
    private lazy var linkLayer: CAShapeLayer = {
        let linkLayer = CAShapeLayer()
        linkLayer.strokeColor = UIColor.orange.cgColor
        linkLayer.fillColor = UIColor.clear.cgColor
        linkLayer.lineWidth = 2
        view.layer.insertSublayer(linkLayer, at: 0)
        return linkLayer
    }()
    
    private lazy var legendStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalSpacing
        sv.axis = .vertical
        sv.isHidden = isLegendHidden
        return sv
    }()
    
    lazy var radiographyButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("💀", for: .normal)
        button.tintColor = UIColor(hexString: "50E3C2")
        button.backgroundColor = UIColor(hexString: "262938")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = isRadiographyButtonHidden
        button.addTarget(self, action: #selector(radiographyWasPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var randomButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 25
        button.setTitle("🔄", for: .normal)
        button.tintColor = UIColor(hexString: "50E3C2")
        button.backgroundColor = UIColor(hexString: "262938")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = !randomAvailable
        button.addTarget(self, action: #selector(randomWasPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var simulation: Simulation<SkeletonParticle> = {
        let simulation: Simulation<SkeletonParticle> = Simulation()
        simulation.insert(force: manyParticle)
        simulation.insert(force: links)
        simulation.insert(force: center)
        simulation.insert(tick: { particles in
            self.linkLayers.keys.forEach { keys in
                self.graph.apsConnections.forEach {
                    let from = $0.from
                    let to = $0.to
                    let fromParticle = particles.filter{ $0.identifier == from.id }.first!
                    let toParticle = particles.filter{ $0.identifier == to.id }.first!
                    var set = Set<SkeletonParticle>()
                    set.insert(fromParticle)
                    set.insert(toParticle)
                    
                    let value = self.linkLayers[set.hashValue]!
                    value.path = self.links.path(from: &set)
                }
                
                self.graph.hostConnections.forEach {
                    let from = $0.from
                    let to = $0.to
                    let fromParticle = particles.filter{ $0.identifier == from.id }.first!
                    let toParticle = particles.filter{ $0.identifier == to.id }.first!
                    var set = Set<SkeletonParticle>()
                    set.insert(fromParticle)
                    set.insert(toParticle)
                    
                    let value = self.linkLayers[set.hashValue]!
                    value.path = self.links.path(from: &set)
                }
            }
        })
        return simulation
    }()
    
    // MARK: - Life cycle
    public init(graph: Graph) {
        super.init(nibName: nil, bundle: nil)
        self.graph = graph
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(legendStackView)
        view.addSubview(randomButton)
        view.addSubview(radiographyButton)
        let buttonCons: [Constraint] = [
            .trailing(constant: -20),
            .top(constant: 20),
            .height(constant: 50),
            .width(constant: 50)
        ]
        NSLayoutConstraint.activate(buttonCons.map{$0.generateNSLayoutContraint(view, radiographyButton)})
        
        let randomButtonCons: [Constraint] = [
            .trailing(constant: -90),
            .top(constant: 20),
            .height(constant: 50),
            .width(constant: 50)
        ]
        NSLayoutConstraint.activate(randomButtonCons.map{$0.generateNSLayoutContraint(view, randomButton)})
        
        let cons: [Constraint] = [
            .leading(constant: 0),
            .trailing(constant: 0),
            .bottom(constant: 0)]
        NSLayoutConstraint.activate(cons.map{$0.generateNSLayoutContraint(view, legendStackView)})
        legend.sorted(by: {$0.key < $1.key}).forEach{ (key, value) in
            let l = UILabel()
            l.text = "\(value.keys.first!)"
            l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            l.backgroundColor = value.values.first!
            l.textAlignment = .center
            legendStackView.addArrangedSubview(l)
            l.sizeToFit()
        }
        
        
        view.backgroundColor = .white
        createUIGraph()
    }
    
    func createUIGraph() {
        linkLayers.removeAll()
        simulation.particles.removeAll()
        accessPointsCreated.removeAll()
        links.links.removeAll()
        links.degrees.removeAll()
        view.layer.sublayers?.filter{ lay in
            let l = (lay as? CAShapeLayer)?.name ?? ""
            return l == "Connection"
        }.forEach{$0.removeFromSuperlayer()}
    
        view.subviews.filter{$0.frame.width == 50 && !($0 is UIButton)}.forEach{$0.removeFromSuperview()}
        
        graph.accessPoints.forEach { ap in
            let particle = createParticle(graphElement: ap)
            simulation.insert(particle: particle)
            ap.hosts.forEach { h in
                let hParticle = createParticle(graphElement: h)
                simulation.insert(particle: hParticle)
                links.link(between: hParticle, and: particle, distance: 100)
            }
            accessPointsCreated.insert(particle)
            
        }
        
        graph.apsConnections.forEach {
            let from = $0.from
            let to = $0.to
            let fromParticle = simulation.particles.first(where: { $0.identifier == from.id })!
            let toParticle = simulation.particles.first(where: { $0.identifier == to.id })!
            links.link(between: fromParticle, and: toParticle, distance: 150)
            var particles = Set<SkeletonParticle>()
            particles.insert(fromParticle)
            particles.insert(toParticle)
            let layer = createLayer(connection: $0)
            linkLayers[particles.hashValue] = layer
            view.layer.insertSublayer(layer, at: 0)
        }
        
        graph.hostConnections.forEach {
            let from = $0.from
            let to = $0.to
            let fromParticle = simulation.particles.first(where: { $0.identifier == from.id })!
            let toParticle = simulation.particles.first(where: { $0.identifier == to.id })!
            links.link(between: fromParticle, and: toParticle, distance: 100)
            var particles = Set<SkeletonParticle>()
            particles.insert(fromParticle)
            particles.insert(toParticle)
            let layer = createLayer(connection: $0)
            linkLayers[particles.hashValue] = layer
            view.layer.insertSublayer(layer, at: 0)
        }
        
        simulation.start()
    }
    
    public func createLayer<T: GraphElement, U: GraphElement>(connection: Connection<T, U>) -> CAShapeLayer {
        var color: UIColor = .clear
        var lineWidth: CGFloat = 0
        var dash: Bool = false
        switch connection.technology {
        case .ethernet:
            color = .red
            lineWidth = 2
        case .fiber:
            color = .blue
            lineWidth = 5
        case .wifi:
            color = .orange
            lineWidth = 1
            dash = true
        }
        let linkLayer = CAShapeLayer()
        linkLayer.strokeColor = color.cgColor
        linkLayer.fillColor = UIColor.clear.cgColor
        linkLayer.lineWidth = lineWidth
        linkLayer.name = "Connection"
        if dash {linkLayer.lineDashPattern = [3, 3] }
        return linkLayer
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        center.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        simulation.start()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        simulation.stop()
    }
    
    // MARK: - private api
    
    private func createParticle<T: GraphElement>(graphElement: T) -> SkeletonParticle {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        container.center = CGPoint(x: CGFloat((0..<320).randomElement() ?? 0), y: -CGFloat((0..<100).randomElement() ?? 0))
        self.view.addSubview(container)
        
        let layer = CAShapeLayer()
        layer.frame = container.bounds
        layer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath
        layer.fillColor = graphElement.color.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 2
        container.layer.insertSublayer(layer, at: 0)
        
        let view = SkeletonPiece(tissue: graphElement.image, bone: graphElement.mutatedImage)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        let cons: [Constraint] = [
            .width(constant: 30),
            .height(constant: 30),
            .centerX(constant: 0),
            .centerY(constant: 0)
        ]
        
        NSLayoutConstraint.activate(cons.map{$0.generateNSLayoutContraint(container, view)})
        
        let gestureRecogizer = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
        container.addGestureRecognizer(gestureRecogizer)
        
        return SkeletonParticle(view: container, identifier: graphElement.id)
    }
    
    @objc private func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view, let index = simulation.particles.index(of: SkeletonParticle(view: view, identifier: "")) else { return }
        var particle = simulation.particles[index]
        switch gestureRecognizer.state {
        case .began:
            particle.fixed = true
        case .changed:
            particle.position = gestureRecognizer.location(in: self.view)
            simulation.kick()
        case .cancelled, .ended:
            particle.fixed = false
            particle.velocity += gestureRecognizer.velocity(in: self.view) * 0.05
        default:
            break
        }
        simulation.particles.update(with: particle)
    }
    
    @objc private func radiographyWasPressed(_ sender: UIButton) {
        isRadiographyButtonHidden = true
        if randomAvailable { isRandomHidden = true }
        isLegendHidden = true
        let currentViewImage = view.image!
        simulation.particles.forEach{$0.mutate()}
        let bgImV = UIImageView(image: UIImage(named: "background"))
        bgImV.frame = view.frame
        view.insertSubview(bgImV, at: 0)
        let mutatedImage = view.image!
        let sliding = SlidingView(left: UIImageView(image: currentViewImage), right: UIImageView(image: mutatedImage)) { [unowned self] vc in
            self.simulation.particles.forEach{$0.mutate()}
            bgImV.removeFromSuperview()
            self.isRadiographyButtonHidden = false
            self.isLegendHidden = false
            if self.randomAvailable { self.isRandomHidden = false }
            vc.dismiss(animated: false, completion: nil)
        }
        present(sliding, animated: false, completion: nil)
        
    }
    
    @objc private func randomWasPressed(_ sender: UIButton) {
        createUIGraph()
    }
    
}
