//
//  ConeNode.swift
//  pinocchio
//
//  Created by Fan Yang on 9/25/20.
//

import SceneKit


class ConeNode: SCNNode {
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    override init() {
        super.init()
        
        let cone = SCNCone(topRadius: 0.001, bottomRadius: 0.005, height: 0.01)
        //sphere.segmentCount = 3
        //cone.firstMaterial?.diffuse.contents = UIImage(named: "wood-texture")
        
        let sideMaterial = SCNMaterial()
        sideMaterial.diffuse.contents = UIImage(named: "wood-texture")
        
        let topMaterial = SCNMaterial()
        topMaterial.diffuse.contents = UIColor.yellow
        
        let bottomMaterial = SCNMaterial()
        bottomMaterial.diffuse.contents = UIColor.blue
        
        cone.materials = [sideMaterial,topMaterial,bottomMaterial]
        
        geometry = cone
        //rotation =  SCNVector4Make(1, 0, 0, .pi/2)
    }
    
    func update(topRadius:CGFloat, bottomRadius:CGFloat, height:CGFloat){
        let cone = geometry as? SCNCone
        cone?.topRadius = topRadius
        cone?.bottomRadius = bottomRadius
        cone?.height = height
        
        
    }
    
    func animateLengthIncrease(by:CGFloat){
        SCNTransaction.animationDuration = 1.0
        if let cone = geometry as? SCNCone{
            pivot = SCNMatrix4MakeTranslation(0, -0.5 * Float(cone.height), 0)
            cone.height += by
            cone.bottomRadius = cone.bottomRadius * 1.02
        }
    }
    
    func reset(){
        SCNTransaction.animationDuration = 1.5
        if let cone = geometry as? SCNCone{
            pivot = SCNMatrix4MakeTranslation(0, -0.5 * Float(cone.height), 0)
            cone.height = 0.01
            cone.topRadius = 0.001
            cone.bottomRadius = 0.005
        }
    }

    
    func update(for vectors: [vector_float3],eulerAngles: SCNVector3, rotation: SCNVector4) {
        if let cone = geometry as? SCNCone{
            pivot = SCNMatrix4MakeTranslation(0, -0.5 * Float(cone.height), 0)
            
            self.eulerAngles = eulerAngles
            self.rotation = rotation
        }
        let newPos = vectors.reduce(vector_float3(), +) / Float(vectors.count)
        position = SCNVector3(newPos)
        
        
        
        //geometry?.firstMaterial?.diffuse.contents = color
    }
    
    
}
