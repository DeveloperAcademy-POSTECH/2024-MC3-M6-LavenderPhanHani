//
//  BackgroundBlur.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

/// A transparent View that blurs its background
struct BackgroundBlur: View {
    var radius: CGFloat
    var opaque: Bool = true
    
    var body: some View {
            BackdropView().blur(radius: radius, opaque: opaque)
    }
}

struct BackdropView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

#Preview {
    BackgroundBlur(radius: 5)
}
