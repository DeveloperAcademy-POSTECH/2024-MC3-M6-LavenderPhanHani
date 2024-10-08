//
//  NagiHome.swift
//  Nap
//
//  Created by YunhakLee on 8/2/24.
//

import SwiftUI
import ActivityKit

import SwiftUI
import Combine

class TimerData: ObservableObject {
    @Published var timeInterval: Double = 0
}


struct Home: View {
    @EnvironmentObject var timerData: TimerData
    //@Binding var showHome: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - 각도 및 프로그레스 바
    
    @State var currentTime: Date = Date()
    @State var startAngle: Double = 0
    @State var timeInterval: Double = 0
    @State var moveNext = false
    // Since our to progress is 0.5
    // 0.5 * 360 = 180
    @State var toAngle: Double = 180
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    
    // MARK: - 햅틱
    @State private var lastHapticAngle: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: topMargin)
            Header
            Spacer().frame(height: 12)
            if !UIScreen.isSE {
                FriendSection
                Spacer().frame(height: 24)
            }
            NapSettingSection
            Spacer()
            MoveFeedButton
            Spacer().frame(height: bottomMargin)
        }
        .background {
            Image(.basicBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: UIScreen.size.width,
                       height: UIScreen.size.height)
                .clipped()
        }
        .navigationDestination(isPresented: $moveNext) {
            SilentModeCheckView(timeInterval: $timeInterval)
        }
    }
}

private extension Home {
    
    // MARK: View - Header
    
    var Header: some View {
        HStack {
            HomeTitle
            Spacer()
            FriendCount
        }
        .padding(.leading, 30)
        .padding(.trailing, 20)
        .padding(.vertical, 6)
    }
    
    var HomeTitle: some View {
        Image(.inAppLogo)
    }
    
    var FriendCount: some View {
        NavigationLink {
            Friend()
        } label: {
            HStack(spacing: 0) {
                Image(.users)
                Spacer().frame(width: 4)
                Text("친구")
                    .font(.napCaption1)
                Spacer().frame(width: 12)
                Text("4")
                    .font(.napCaption1)
                Spacer().frame(width: 2)
                Text("/")
                    .font(.napCaption3)
                    .foregroundStyle(.napWhite40)
                Spacer().frame(width: 2)
                Text("6")
                    .font(.napCaption1)
                    .foregroundStyle(.napWhite40)
            }
            .foregroundStyle(.napWhite100)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background {
                Capsule()
                    .foregroundStyle(.napWhite10)
            }
            .overlay {
                Capsule()
                    .stroke(.napWhite10, lineWidth: 1.0)
            }
        }
    }
    
    // MARK: View - Awake Friends
    
    var FriendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FriendTitle
            
            HStack(spacing: 12) {
                FriendCircle(name: "fox")
                FriendCircle(name: "pilot")
                FriendCircle(name: "prince")
            }
        }
        .padding(.leading, 30)
    }
    
    var FriendTitle: some View {
        Text("지금 깨어있는 친구들")
            .font(.napCaption2)
            .foregroundStyle(.napWhite60)
    }
    
    func FriendCircle(name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.napWhite10, lineWidth: 2.0)
                    .frame(width: 42, height: 42)
            }
    }
    
    // MARK: View - Setting NapTime
    
    var NapSettingSection: some View{
        VStack(alignment: .leading, spacing: SectionTitleSpacing) {
            NapSettingTitle
                .padding(.leading, 30)
            TimerSetting
                .padding(.horizontal, 20)
        }
    }
    
    var NapSettingTitle: some View {
        Text("낮잠 설정하기")
            .font(.napCaption2)
            .foregroundStyle(.napWhite60)
    }
    
    var TimerSetting: some View {
        VStack(alignment: .leading, spacing: 0) {
            TimerTitle
            Spacer().frame(height: 6)
            TimerTimeIntervalText
            Spacer().frame(height: UIScreen.isSE ? 16 : 20)
            TimerView
            Spacer().frame(height: UIScreen.isSE ? 26 : 30)
            StartNapButton
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.napWhite10)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.napWhite10, lineWidth: 1.0)
        }
    }
    
    var TimerTitle: some View {
        HStack(spacing: 4) {
            Image(.moon)
            Text("낮잠 시간")
                .font(.napCaption1)
                .foregroundStyle(.napBlue100)
        }
    }
    
    var TimerTimeIntervalText: some View {
        HStack(spacing: 4) {
            Text(formatTimeRange(date: currentTime))
                .onReceive(timer) {
                    currentTime = $0
                }
            Text("-")
            Text(formatTimeRange(date: updateWakeupTime()))
        }
        .font(.napTitle1)
        .foregroundStyle(.napWhite100)
    }
    
    var TimerView: some View {
        ZStack {
            Circle()
                .foregroundStyle(.napWhite10)
            Image(.timerBackground)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.size.width-140,
                       height: UIScreen.size.width-140)
                .clipShape(Circle())
            
            ForEach(1...60, id: \.self) { index in
                Rectangle()
                    .fill(index % 5 == 0 ? .napWhite100
                                         : .napWhite20)
                // Each hour will have big Line
                // 60/5 = 12
                // 12 Hours
                    .frame(width: 2,
                           height: index % 5 == 0 ? 10 : 8)
                // Setting into entire Circle
                    .offset(y: (UIScreen.size.width/2) - 83)
                    .rotationEffect(.init(degrees: Double(index) * 6))
            }
            
            let timeTexts = [60, 90, 120, 30]
            ForEach(timeTexts.indices, id: \.self) { index in
                Text("\(timeTexts[index])")
                    .font(.napFootnote1)
                    .foregroundColor(.napWhite80)
                    .rotationEffect(.degrees(Double(index) * -90))
                    .offset(y: (UIScreen.size.width/2) - 99.5)
                    .rotationEffect(.degrees(Double(index) * 90))
            }
            
            // Allowing Reverse Swiping
            let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
            Circle()
                .trim(from: startProgress > toProgress ? 0 : startProgress,
                      to: toProgress + (-reverseRotation / 360))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.napBlue201, .napBlue201]),
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)),
                    style: StrokeStyle(lineWidth: 30,
                                       lineCap: .round,
                                       lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .rotationEffect(.degrees(reverseRotation))
                .frame(width: UIScreen.size.width-110,
                       height: UIScreen.size.width-110)
            
            // Fixed Buttons
            Image(.tiredPrince)
                .frame(width: 24, height: 24)
                .background {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(.napWhite20)
                }
            // Moving To Right & Rotating
                .offset(y: -(UIScreen.size.width-110)/2)
            
            // Slider Buttons
            Image(.freshPrince)
                .frame(width: 24, height: 24)
                .background {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(.napWhite20)
                }
            // Rotating Image inside the Circle
                .rotationEffect(.degrees(90))
                .rotationEffect(.degrees(-toAngle))
            //Moving To Right & Rotating
                .offset(x: (UIScreen.size.width-110)/2)
            // To the Current Angle
                .rotationEffect(.degrees(toAngle))
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            onDrag(value: value)
                        })
                )
                .rotationEffect(.init(degrees: -90))
            
                Text(formatTime(getMinuteDifference()*60))
                .font(.napDisplay)
                .foregroundStyle(.napWhite100)
        }
        .frame(width: UIScreen.size.width-80,
               height: UIScreen.size.width-80)
    }
    
    var StartNapButton: some View {
        Button {
            timeInterval = Double(getMinuteDifference()*60)
            timerData.timeInterval = Double(getMinuteDifference() * 60)
            addLiveActivity()
            moveNext = true
        } label: {
            MainButtonLabel(text: "낮잠 자러가기")
        }
    }
    
    var MoveFeedButton: some View {
//        Button {
//            print("화면 내려가기")
//        } label: {
            HStack(alignment: .center) {
                Spacer()
                VStack(spacing: 1) {
                    Image(.chevronUp)
                        .rotationEffect(.degrees(180))
                    Text("친구들 낮잠 피드 보러가기")
                        .font(.napCaption1)
                }
                .foregroundStyle(.napWhite60)
                .padding(.vertical, 13)
                Spacer()
            }
        //}
    }
    
    // MARK: Computed Values
    
    func formatTimeRange(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        
        return formatter.string(from: date)
    }
    
    /// 현재시간
    func currentKSTTime() -> Date {
        let now = Date()
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let secondsFromGMT = timeZone.secondsFromGMT(for: now)
        return now.addingTimeInterval(TimeInterval(secondsFromGMT - TimeZone.current.secondsFromGMT(for: now)))
    }
    
    /// 일어날 시간
    func updateWakeupTime() -> Date {
        let now = currentTime
        let addedMinutes = getMinuteDifference()
        return Calendar.current.date(byAdding: .minute, value: addedMinutes, to: now) ?? now
    }
    
    /// 각도에서 시간 차이를 구해낸다.
    func getMinuteDifference() -> Int {
        let startMinutes = getMinutes(angle: startAngle)
        let endMinutes = getMinutes(angle: toAngle)
        return (endMinutes - startMinutes + 120) % 120
    }
    
    /// 각도에서 분을 얻어낸다.
    func getMinutes(angle: Double) -> Int {
        let progress = angle / 3
        return Int(progress) % 120
    }
    
    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        let remainingSeconds = seconds % 60
        
        return String(format: "%01d:%02d:%02d", hours, minutes, remainingSeconds)
    }
    
    //moon.fill 고정
    func onDrag(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        let progress = angle / 360
        
        self.toAngle = angle
        self.toProgress = progress
        //HapticManager.instance.impact(style: .light)
        if abs(angle - lastHapticAngle) >= 2 {
            HapticManager.instance.impact(style: .light)
            lastHapticAngle = angle
        }
    }
    
    func addLiveActivity() {
        let napStatusAttributes = NapStatusAttributes()
        let intialContentState = NapStatusAttributes.ContentState(remainingTime: Int(timeInterval))
        
        do {
            let activity = try Activity<NapStatusAttributes>.request(attributes: napStatusAttributes, contentState: intialContentState, pushType: nil)
            print("Activity Added Successfully. id: \(activity.id)")
        } catch {
            print(error.localizedDescription)
        }
    }
    

    
    var topMargin: CGFloat {
        UIScreen.isSE ? 20 : 54
    }
    
    var SectionTitleSpacing: CGFloat {
        UIScreen.isSE ? 8 : 12
    }
    
    var bottomMargin: CGFloat {
        UIScreen.isSE ? 0 : 21
    }
}

#Preview {
    ContentView()
}

#Preview {
    Home()
}

