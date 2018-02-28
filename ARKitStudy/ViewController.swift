//
//  ViewController.swift
//  ARKitStudy
//
// 説明リンク：https://www.appcoda.com.tw/arkit-introduction-scenekit/
//
//  Created by Phoenix Wu on H30/02/28.
//  Copyright © 平成30年 Phoenix Wu. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else {
            // box 以外のところをタップしたら、新しいボックスをタップされたところに追加する
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
            if let hitTestResultsWithFeaturePoint = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultsWithFeaturePoint.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            
            return
        }
        
        // タップされた box を削除する
        node.removeFromParentNode()
    }
    
    /**
     Add box into scene view
     */
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        // 示す box
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        // 座標
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // AR configuration 初期化
        let configuration = ARWorldTrackingConfiguration()
        
        // world tracking 起動
        sceneView.session.run(configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addBox()
        addTapGestureToSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // world tracking 停止
        sceneView.session.pause()
    }


}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
















