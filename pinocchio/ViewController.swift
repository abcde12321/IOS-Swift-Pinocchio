//
//  ViewController.swift


import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    //let noseOptions = ["nose01", "nose02", "nose03", "nose04", "nose05", "nose06", "nose07", "nose08", "nose09"]
    //let features = ["nose"]
    //var noseVertices = []
    var featureIndices = [[6]]
    
    var noseNode:ConeNode?
    var occlusionNode: SCNNode!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuratio = ARFaceTrackingConfiguration()
        sceneView.session.run(configuratio)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        //let location = sender.location(in: sceneView)
        //let results = sceneView.hitTest(location, options: nil)
        print("double tap on the screen")
        noseNode?.animateLengthIncrease(by: 0.01)
        //if let result = results.first,
            //let node = result.node /*as? FaceNode*/ {
            
        //}
    }
    
    
    @IBAction func resetBtnTouched(_ sender: UIButton) {
        noseNode?.reset()
    }
    
    /*func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        //print(featureIndices)
        for (feature, indices) in zip(features, featureIndices) {
            let child = node.childNode(withName: feature, recursively: false) as? FaceNode
            let vertices = indices.map { anchor.geometry.vertices[$0] }
            child?.updatePosition(for: vertices)
        }
    }*/
    
}

extension ViewController: ARSCNViewDelegate {
    //update once
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return nil
        }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        faceGeometry!.firstMaterial!.colorBufferWriteMask = []
        let node = SCNNode(geometry: faceGeometry)
        //let node = SCNNode()
        
        occlusionNode = SCNNode(geometry: faceGeometry)
        occlusionNode.renderingOrder = -1
        
        //node.geometry?.firstMaterial?.fillMode = .lines
        //node.geometry?.firstMaterial?.transparency = 0.0
        
        
        //let noseNode = FaceNode(with: noseOptions)
        noseNode = ConeNode()
        noseNode?.name = "nose"
        node.addChildNode(occlusionNode!)
        node.addChildNode(noseNode!)
        
        
        //updateFeatures(for: node, using: faceAnchor)
        
        return node
    }
    
    //continues update
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        //updateFeatures(for: node, using: faceAnchor)
        
        for childNode in node.childNodes{
            //print("child node:")
            if childNode.name == "nose"{
                //print("update nose position")
                let nose = childNode as? ConeNode
                //nose?.eulerAngles = node.eulerAngles
                //nose?.rotation = SCNVector4Make(1, 0, 0, .pi/2)
                //faceAnchor.lookAtPoint
                
                let noseIndexes = [156,127,605,576]
                nose?.update(for: noseIndexes.map{faceAnchor.geometry.vertices[$0]}, eulerAngles: node.eulerAngles, rotation: SCNVector4Make(1, 0, 0, .pi/2))
                //nose?.update(for: [faceAnchor.geometry.vertices[8]])
                
                //nose?.eulerAngles.x = node.eulerAngles.x + .pi/4
                //nose?.simdEulerAngles = faceAnchor.lookAtPoint
                
                //nose?.simdRotation =
            }
        }
    }
    
    
}

