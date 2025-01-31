//
//  ARContentView.swift
//  HelloARKit
//
//  Created by Chloe Lauren on 12/31/24.
//

import SwiftUI
import ARKit
import RealityKit

let arView = ARView(frame: .zero)

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        
        // 配置 AR 会话
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal] // 检测水平平面
        arView.session.run(configuration)
        
        // 添加一个平面锚点的可视化委托
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ARContentView: View {
    @Binding var showARView: Bool

    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { location in
                    // 点击屏幕在检测到的平面上放置一个物体
                    placeObject(at: location)
                }
            VStack {
                HStack {
                    Spacer()
                    Button() {
                        showARView.toggle()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20) // 添加右侧的内边距
                }
                Spacer() // 剩余空间推到底部文本
            }
            
            // 底部文字
            VStack {
                Spacer() // 推到页面底部
                Text("点击平面以放置物体")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 20)
            }
            
            .padding(24)
        }
    }
    
    private func placeObject(at point: CGPoint) {
        // 使用用户点击的屏幕坐标进行射线检测
        let raycastResults = arView.raycast(from: point, allowing: .estimatedPlane, alignment: .horizontal)
        if let firstResult = raycastResults.first {
            let transform = firstResult.worldTransform
            let position = SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)

            // 随机生成一个实体
            let randomEntity = generateRandomEntity()
            let anchor = AnchorEntity(world: position)
            anchor.addChild(randomEntity)
            arView.scene.addAnchor(anchor)
        } else {
            print("未检测到有效平面，无法放置物体")
        }
    }
    
    private func placeRandomObject_center() {
        // 获取屏幕中心点
        let screenCenter = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        
        // 使用射线检测从屏幕中心点向场景中检测水平平面
        let raycastResults = arView.raycast(from: screenCenter, allowing: .estimatedPlane, alignment: .horizontal)
        if let firstResult = raycastResults.first {
            // 获取射线检测的结果位置
            let transform = firstResult.worldTransform
            let position = SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            // 随机生成一个实体
            let randomEntity = generateRandomEntity()
            
            // 创建锚点，并将随机实体放置在锚点上
            let anchor = AnchorEntity(world: position)
            anchor.addChild(randomEntity)
            
            // 添加锚点到场景
            arView.scene.addAnchor(anchor)
        } else {
            print("未检测到有效平面，无法放置物体")
        }
    }
    
    private func generateRandomEntity() -> ModelEntity {
        let randomIndex = Int.random(in: 0..<3)
        let randomSize = Float.random(in: 0..<0.15)
        let randomColor = Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
        switch randomIndex {
        case 0:
            return ModelEntity(mesh: .generateSphere(radius: randomSize), materials: [SimpleMaterial(color: UIColor(randomColor), isMetallic: Bool.random())])
        case 1:
            return ModelEntity(mesh: .generateBox(size: [randomSize, randomSize, randomSize]), materials: [SimpleMaterial(color: UIColor(randomColor), isMetallic: Bool.random())])
        case 2:
            return ModelEntity(mesh: .generateCylinder(height: randomSize, radius: randomSize), materials: [SimpleMaterial(color: UIColor(randomColor), isMetallic: Bool.random())])
        case 3:
            return ModelEntity(mesh: .generateCone(height: randomSize, radius: randomSize), materials: [SimpleMaterial(color: UIColor(randomColor), isMetallic: Bool.random())])
        default:
            fatalError("Unexpected random index")
        }
    }
}

//#Preview {
//    ARContentView()
//}
