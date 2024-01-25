//
//  DistanceFaceAndDevice.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import ARKit
import SwiftUI

struct DistanceFaceAndDevice: UIViewRepresentable {
    
    @ObservedObject var distance: DistanceModel
    
    init(distance: DistanceModel) {
        self.distance = distance
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: DistanceFaceAndDevice
        var faceNode = SCNNode()
        var leftEye = SCNNode()
        var rightEye = SCNNode()

        init(parent: DistanceFaceAndDevice) {
            self.parent = parent
        }

        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }

            // 여기에서 faceAnchor를 사용하여 얼굴의 다양한 특징에 접근할 수 있습니다.
            faceNode = node
            faceNode.addChildNode(leftEye)
            faceNode.addChildNode(rightEye)
            faceNode.transform = node.transform
            
            trackDistance(leftEye: leftEye, rightEye: rightEye)
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            faceNode.transform = node.transform

            //2. Check We Have A Valid ARFaceAnchor
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            
            //3. Update The Transform Of The Left & Right Eyes From The Anchor Transform
            leftEye.simdTransform = faceAnchor.leftEyeTransform
            rightEye.simdTransform = faceAnchor.rightEyeTransform
            
            //4. Get The Distance Of The Eyes From The Camera
            trackDistance(leftEye: leftEye, rightEye: rightEye)
        }
        
        func trackDistance(leftEye: SCNNode, rightEye: SCNNode) {
            //4. Get The Distance Of The Eyes From The Camera
            let leftEyeDistanceFromCamera = self.leftEye.worldPosition - SCNVector3Zero
            let rightEyeDistanceFromCamera = self.rightEye.worldPosition - SCNVector3Zero
            
            //5. Calculate The Average Distance Of The Eyes To The Camera
            let averageDistance = (leftEyeDistanceFromCamera.length() + rightEyeDistanceFromCamera.length()) / 2
            let averageDistanceCM = (Int(round(averageDistance * 100)))
            Task {
                await parent.distance.inputDistance(averageDistanceCM)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator

        let scene = SCNScene()
        arView.scene = scene

        let configuration = ARFaceTrackingConfiguration()
        arView.session.run(configuration)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // SwiftUI 뷰가 업데이트될 때 호출됩니다.
    }
}

extension SCNVector3{

    ///Get The Length Of Our Vector
    func length() -> Float { return sqrtf(x * x + y * y + z * z) }

    ///Allow Us To Subtract Two SCNVector3's
    static func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 { return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z) }
}
