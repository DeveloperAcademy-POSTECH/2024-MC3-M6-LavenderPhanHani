//
//  OnboardingView.swift
//  WakeMeUp_Trial
//
//  Created by Leo Yoon on 7/25/24.
//

import SwiftUI

struct OnboardingView2: View {
    @EnvironmentObject var screenSize: ScreenSize
    
    var body: some View{
        ZStack{
            BGTest()
            VStack(alignment:.center){
                HStack{
                    Text("자는동안 걱정말아요\n친구들이 깨워줄 거에요")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                    Spacer()
                }
                .frame(width: screenSize.width - 80)
                
                Spacer()
                
                Image("BG_Onboarding2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width - 80)
                    .padding(.bottom, 32)
                
                // 도트표시
                HStack{
                    Circle()
                        .frame(width:8)
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                    
                    Circle()
                        .frame(width:8)
                        .foregroundColor(.purple)
                        .padding(.trailing, 8)
                    
                    Circle()
                        .frame(width:8)
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                    
                    Circle()
                        .frame(width:8)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 32)
                
                Button(action:{
                    // 다음으로 넘어가기
                }, label:{
                    ZStack{
                        Rectangle()
                            .frame(width: screenSize.width - 60, height: 56)
                            .cornerRadius(6)
                            .foregroundColor(.purple)
                        Text("다음")
                            .font(.system(size:16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                })
                .padding(.bottom, 24)
                
            }
        }
    }
}

#Preview{
    OnboardingView2()
        .environmentObject(ScreenSize())
}
