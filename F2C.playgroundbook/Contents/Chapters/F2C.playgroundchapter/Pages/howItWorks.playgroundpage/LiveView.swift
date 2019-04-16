import UIKit
import PlaygroundSupport

var graph = BasicScenarioGraph()
graph.generate()
let vc = GraphViewController(graph: graph)
vc.isRadiographyButtonHidden = false
vc.isLegendHidden = false
PlaygroundPage.current.liveView = vc


