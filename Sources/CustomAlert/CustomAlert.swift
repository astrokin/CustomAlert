//
//  CustomAlert.swift
//  CustomAlert
//
//  Created by David Walter on 03.04.22.
//

import SwiftUI

/// Custom Alert
struct CustomAlert<Content, Actions>: View where Content: View, Actions: View {
    var title: Text?
    var modifiers: CustomAlertModifiers
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> Content
    @ViewBuilder var actions: () -> Actions
    
    // Size holders to enable scrolling of the content if needed
    @State private var viewSize: CGSize = .zero
    @State private var contentSize: CGSize = .zero
    @State private var actionsSize: CGSize = .zero
    
    @State private var fitInScreen = false
    
    // Used to animate the appearance
    @State private var isShowing = false
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                if isShowing {
                    alert
                        .animation(nil, value: height)
                }
                Spacer()
            }
        }
        .captureSize($viewSize)
        .onAppear {
            withAnimation {
                isShowing = true
            }
        }
    }
    
    var height: CGFloat {
        // View height - padding top and bottom - actions height
        let maxHeight = viewSize.height - 60 - actionsSize.height
        let min = min(maxHeight, contentSize.height)
        return max(min, 0)
    }
    
    var minWidth: CGFloat {
        // View width - padding leading and trailing
        let maxWidth = viewSize.width - 60
        // Make sure it fits in the content
        let min = min(maxWidth, contentSize.width)
        return max(min, 0)
    }
    
    var maxWidth: CGFloat {
        // View width - padding leading and trailing
        let maxWidth = viewSize.width - 60
        // Make sure it fits in the content
        let min = min(maxWidth, contentSize.width)
        // Smallest AlertView should be 270
        return max(min, 270)
    }
    
    var alert: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: 4) {
                        title?
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        content()
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .captureSize($contentSize)
                    // Force `Environment.isEnabled` to `true` because outer ScrollView is most likely disabled
                    .environment(\.isEnabled, true)
                }
                .frame(height: height)
                .onUpdate(of: contentSize) { contentSize in
                    fitInScreen = contentSize.height <= proxy.size.height
                }
                .scrollViewDisabled(fitInScreen)
            }
            .frame(height: height)
            
            _VariadicView.Tree(ContentLayout(isPresented: $isPresented, needsHorizontalDivider: modifiers.needsHorizontalDivider), content: actions)
                .buttonStyle(.alert)
                .captureSize($actionsSize)
        }
        .frame(minWidth: minWidth, maxWidth: maxWidth)
        .modifier(modifiers.backgroundView())
        .transition(.opacity.combined(with: .scale(scale: 1.1)))
        .animation(.default, value: isPresented)
    }
}

public struct CustomAlertModifiers  {
    public let backgroundView: () -> (CustomAlertBackgroundModifier)
    public let needsHorizontalDivider: Bool
    
    public init(backgroundView: @escaping () -> (CustomAlertBackgroundModifier), needsHorizontalDivider: Bool = true) {
        self.backgroundView = backgroundView
        self.needsHorizontalDivider = needsHorizontalDivider
    }
}

public struct CustomAlertBackgroundModifier: ViewModifier {
    
    public enum BackgroundStyle {
        case blur(UIBlurEffect.Style)
        case color(Color)
    }
    
    public var padding: CGFloat
    public var cornerRadius: CGFloat
    public var background: BackgroundStyle
    
    public init(padding: CGFloat = 8, cornerRadius: CGFloat = 12, background: BackgroundStyle) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.background = background
    }
    
    public func body(content: Content) -> some View {
        switch background {
        case .blur(let style):
            content
                .background(BlurView(style: style))
                .cornerRadius(cornerRadius)
                .padding(padding)
        case .color(let color):
            content
                .background(color)
                .cornerRadius(cornerRadius)
                .padding(padding)
        }
    }
}

struct ContentLayout: _VariadicView_ViewRoot {
    @Binding var isPresented: Bool
    
    let needsHorizontalDivider: Bool
    
    func body(children: _VariadicView.Children) -> some View {
        VStack(spacing: 0) {
            ForEach(children) { child in
                if needsHorizontalDivider {
                    Divider()
                }
                child
                    .simultaneousGesture(TapGesture().onEnded { _ in
                        isPresented = false
                        // Workaround for iOS 13
                        if #available(iOS 15, *) { } else {
                            AlertWindow.dismiss()
                        }
                    })
            }
        }
    }
}
