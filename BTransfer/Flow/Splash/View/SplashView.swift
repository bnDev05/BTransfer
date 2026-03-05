//
//  SplashView.swift
//  BTransfer
//
//  Created by Behruz Norov on 04/03/26.
//

import SwiftUI
import CoreData

struct SplashView: View {
    private enum Consts {
        static let animationDuration: Double = 1.0
        static let circleStrokeWidth: CGFloat = 2
        static let circleBaseSize: CGFloat = 120
        static let circleSizeIncrement: CGFloat = 30
        static let iconSize: CGFloat = 60
        
        static let pulseMinScale: CGFloat = 0.9
        static let pulseMaxScale: CGFloat = 1.3
        static let pulseMinOpacity: Double = 0
        static let pulseMaxOpacity: Double = 0.4
        static let rotationDegrees: Double = 360
        static let waveOffset: CGFloat = 10
        
        static let textHighOpacity: Double = 1
        static let textMediumOpacity: Double = 0.6
        static let textLowOpacity: Double = 0.2
        
        static let textSpacing: CGFloat = 20
        static let vStackSpacing: CGFloat = 40
    }
    
    @StateObject private var vm: SplashViewModel
    @State private var circleScale: CGFloat = 0.8
    @State private var iconScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0
    @State private var waveOffset: CGFloat = 0
    
    init(provider: AppProvider, showMain: Binding<Bool>) {
        _vm = StateObject(wrappedValue: SplashViewModel(provider: provider, showMain: showMain))
    }
    
    var body: some View {
        ZStack {
            BackView()
            
            content
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                circleScale = 1.0
                iconScale = 1.1
                textOpacity = 1
            }
            
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                iconScale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 1.2).repeatCount(1, autoreverses: false)) {
                waveOffset = Consts.waveOffset
            }
            
            vm.turnOnAnimations()
            vm.startAnimation()
        }
    }
    
    private var content: some View {
        VStack(spacing: Consts.vStackSpacing) {
            circleAnimation
            textsView
        }
    }
    
    private var circleAnimation: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(Color.blue.opacity(0.25 - Double(index) * 0.05), lineWidth: Consts.circleStrokeWidth)
                    .frame(
                        width: Consts.circleBaseSize + CGFloat(index) * Consts.circleSizeIncrement,
                        height: Consts.circleBaseSize + CGFloat(index) * Consts.circleSizeIncrement
                    )
                    .scaleEffect(circleScale + (CGFloat(index) * 0.1))
                    .opacity(1 - (Double(index) * 0.2))
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatCount(1, autoreverses: true)
                            .delay(Double(index) * 0.15),
                        value: circleScale
                    )
            }
            
            Image(systemName: "wave.3.right.circle.fill")
                .font(.system(size: Consts.iconSize))
                .foregroundColor(.blue)
                .scaleEffect(iconScale)
                .animation(
                    Animation.easeInOut(duration: 0.6)
                        .repeatCount(1, autoreverses: true),
                    value: waveOffset
                )
        }
    }
    
    private var textsView: some View {
        VStack(spacing: Consts.textSpacing) {
            Text(Loc.SplashTexts.title)
                .font(.title2)
                .fontWeight(.medium)
                .opacity(vm.pulseAnimation ? Consts.textHighOpacity : Consts.textMediumOpacity)
            
            Text(Loc.SplashTexts.subtitle)
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(vm.pulseAnimation ? Consts.textHighOpacity : Consts.textLowOpacity)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    SplashView(provider: AppProvider(), showMain: .constant(false))
}
