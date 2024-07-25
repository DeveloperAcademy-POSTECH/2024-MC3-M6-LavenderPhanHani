//
//  OnboardingView.swift
//  WakeMeUp_Trial
//
//  Created by Leo Yoon on 7/25/24.
//

import SwiftUI

struct OnboardingView4: View {
    @EnvironmentObject var screenSize: ScreenSize
    
    var body: some View{
        ZStack{
            BGTest()
            VStack(alignment:.center){
                HStack{
                    Text("마음의 짐을 내려놓고,\n잠깐 낮잠을 즐겨볼까요?")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                    Spacer()
                }
                .frame(width: screenSize.width - 80)
                
                Spacer()
                
                Image("BG_Onboarding4")
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
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                    
                    Circle()
                        .frame(width:8)
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                    
                    Circle()
                        .frame(width:8)
                        .foregroundColor(.purple)
                }
                .padding(.bottom, 32)
                
                Button(action:{
                    // 다음으로 넘어가기
                }, label:{
                    ZStack{
                        Rectangle()
                            .frame(width: screenSize.width - 60, height: 56)
                            .cornerRadius(6)
                            .foregroundColor(.white)
                        
                        HStack{
                            Image(systemName:"apple.logo")
                                .font(.system(size:20, weight: .bold))
                                .foregroundColor(.black)

                            Text("Sign in with Apple")
                                .font(.system(size:20, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                })
                .padding(.bottom, 24)
                
            }
        }
    }
}

#Preview{
    OnboardingView4()
        .environmentObject(ScreenSize())
}
