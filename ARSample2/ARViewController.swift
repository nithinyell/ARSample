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

    // MARK: Outlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet var activityIndi: UIActivityIndicatorView!
    @IBOutlet var statusLabel: UILabel!
    
    // MARK: Properties
    var arObject: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.scene = SCNScene()

        DispatchQueue.main.async { [weak self] in
            
            self?.activityIndi.startAnimating()
            self?.statusLabel.text = "Detecting Plane"
            self?.statusLabel.layer.cornerRadius = 5
            self?.statusLabel.layer.masksToBounds = true
        }
        
        //addARObject()
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
        config.planeDetection = .horizontal
        
        sceneView.session.run(config)
    }

      func configureLighting() {
//          sceneView.autoenablesDefaultLighting = true
//          sceneView.automaticallyUpdatesLighting = true
      }
      
      func addARObject() {
        
        guard let arObject = self.arObject, let chairScene = SCNScene(named: arObject + ".dae") else { return }
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

extension ARViewController: ARSCNViewDelegate {
    
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            DispatchQueue.main.async { [weak self] in
                
                self?.activityIndi.stopAnimating()
                self?.activityIndi.hidesWhenStopped = true
                self?.statusLabel.text = "Tap to place object"
                self?.statusLabel.layer.cornerRadius = 5
                self?.statusLabel.layer.masksToBounds = true
            }
        }
      }
}

