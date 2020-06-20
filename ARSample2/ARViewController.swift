//
//  ARViewController.swift
//  ARSample2
//
//  Created by Nithin on 20/06/20.
//  Copyright © 2020 Nithin. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {

      @IBOutlet weak var sceneView: ARSCNView!
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          configureLighting()
          addChair()
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          ARConfig()
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          
          sceneView.session.pause()
      }
      
      private func ARConfig() {
          let config = ARWorldTrackingConfiguration()
          sceneView.session.run(config)
      }

      func configureLighting() {
          sceneView.autoenablesDefaultLighting = true
          sceneView.automaticallyUpdatesLighting = true
      }
      
      func addChair() {
          guard let chairScene = SCNScene(named: "chair.dae") else { return }
             let chairNode = SCNNode()
             let chairSceneChildNodes = chairScene.rootNode.childNodes
                 
             for childNode in chairSceneChildNodes {
                 chairNode.addChildNode(childNode)
             }
                 
          chairNode.position = SCNVector3(0, 0, -0.5)
          chairNode.scale = SCNVector3(0.5, 0.5, 0.5)
          sceneView.scene.rootNode.addChildNode(chairNode)
      }
}
