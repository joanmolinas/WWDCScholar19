import UIKit
import PlaygroundSupport

var graph = RandomScenariosGenerator()
graph.generate()
let vc = GraphViewController(graph: graph)
vc.randomAvailable = true
vc.isRadiographyButtonHidden = false
vc.isLegendHidden = false
PlaygroundPage.current.liveView = vc




