//
//  LaunchView.swift
//  HelloARKit
//
//  Created by Chloe Lauren on 12/31/24.
//

import SwiftUI

struct LaunchView: View {
    @State private var showARView = false
    
    var body: some View {
        if showARView {
            ARContentView(showARView: $showARView) // 切换到 AR 页面
        } else {
            ZStack {
                // 背景
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // 标题
                    Text("Hello ARKit")
                        .lineLimit(nil)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 100)
                    
                    // 插图
                    Image("RCPro-Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .padding(.horizontal, 40)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    Spacer()
                    
                    // 按钮
                    Button(action: {
                        withAnimation {
                            showARView.toggle()
                        }
                    }) {
                        Text("开启体验")
                            .font(.headline)
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(25)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    .padding(.bottom, 50)
                    
                    // 提示语
                    Text("确保有足够的空间进行AR探索")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
