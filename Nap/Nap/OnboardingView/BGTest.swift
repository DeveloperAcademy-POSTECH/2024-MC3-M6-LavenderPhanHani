//
//  BGTest2.swift
//  WakeMeUp_Trial
//
//  Created by Leo Yoon on 7/25/24.
//

import SwiftUI

// 스크린 사이즈 측정을 위해, ObservableObject생성.
class ScreenSize: ObservableObject {
    @Published var width: CGFloat = 0
    @Published var height: CGFloat = 0
    
    func updateSize(size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
}

// 스크린 사이즈 측정 및 배경화면 확정.
struct BGTest: View {
    @EnvironmentObject var screenSize: ScreenSize
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.black, .purple]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.8), .gray.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(1), .black.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
            .frame(width: screenWidth, height: screenHeight)
            .position(x: screenWidth / 2, y: screenHeight / 2)
            .onAppear{
                screenSize.width = screenWidth
                screenSize.height = screenHeight
            }
        }
    }
}

#Preview{
    BGTest()
        .environmentObject(ScreenSize())
}
