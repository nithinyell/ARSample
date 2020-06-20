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
    private var isARObjectedActive = false
    private var newAngleY: Float = 0.0
    private var currentAngleY: Float = 0.0
    private var localtranslatePosition: CGPoint!
    
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
        
        registerGestureRecognizers()
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

    private func registerGestureRecognizers() {
        
        let tapgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addARObject))
        self.sceneView.addGestureRecognizer(tapgestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)

    }
     
    @objc func addARObject(recognizer: UITapGestureRecognizer) {
        
        if isARObjectedActive {
            return
        }
        
        guard let sceneView = recognizer.view as? ARSCNView else{
            return
        }
        
        let touch = recognizer.location(in: sceneView)
        
        let hitTestResults = sceneView.hitTest(touch, types: .existingPlane)
        
        if let hitTest = hitTestResults.first {
            
            guard let arObject = self.arObject, let chairScene = SCNScene(named: arObject + ".dae") else { return }
            let chairNode = SCNNode()
            let chairSceneChildNodes = chairScene.rootNode.childNodes
            
            for childNode in chairSceneChildNodes {
                chairNode.addChildNode(childNode)
            }
            
            chairNode.position = SCNVector3(hitTest.worldTransform.columns.3.x , hitTest.worldTransform.columns.3.y , hitTest.worldTransform.columns.3.z)
            
            sceneView.scene.rootNode.addChildNode(chairNode)
            isARObjectedActive = true
            statusLabel.isHidden = true
        }
    }
    
    @objc func panned(recognizer: UIPanGestureRecognizer){
        
        if recognizer.state == .changed {
            guard let sceneview = recognizer.view as? ARSCNView else {
                return
            }
            let touch = recognizer.location(in: sceneView)
            let translation = recognizer.translation(in: sceneview)
            
            let hitTestResults = self.sceneView.hitTest(touch, options: nil)
            if let hitTest = hitTestResults.first {
                if let parentNode = hitTest.node.parent {
                    
                    self.newAngleY = Float(translation.x) * (Float)(Double.pi)/180
                    self.newAngleY += self.currentAngleY
                    parentNode.eulerAngles.y = self.newAngleY
                }
            }
        }
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
