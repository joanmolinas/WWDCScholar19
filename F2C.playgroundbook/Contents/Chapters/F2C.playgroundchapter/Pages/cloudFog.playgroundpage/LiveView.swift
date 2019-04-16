import UIKit
import PlaygroundSupport

var graph = BasicScenarioGraph()
graph.generate()
let vc = GraphViewController(graph: graph)
PlaygroundPage.current.liveView = vc


