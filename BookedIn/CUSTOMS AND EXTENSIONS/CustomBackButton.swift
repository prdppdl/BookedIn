//
//  CustomBackButton.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import SDWebImageSwiftUI


struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        Button(action: {
            
            self.presentationMode.wrappedValue.dismiss()
            
        }){
            Image(systemName: "chevron.left")
                .frame(width: 10, height: 10)
                .foregroundColor(Color.accentColor)
            
        }
        
    }
}

#Preview {
    CustomBackButton()
}

// CUSTOM TAB BAR

enum TabModel: String, CaseIterable {
    case home = "house"
    case search = "map"
    case notifications = "book"
    case settings = "gearshape"
    
    var title: String {
        switch self {
        case .home: "Home"
        case .search: "Places to book"
        case .notifications: "BookedIns"
        case .settings: "Settings"
        }
    }
}

struct CustomTabBar: View {
    @State private var showProfile: Bool = false
    var activeForeground: Color = .creamy
    var activeBackground: Color = .accentColor
    @Binding var activeTab: TabModel
    /// For Matched Geometry Effect
    @Namespace private var animation
    /// View Properties
    @State private var tabLocation: CGRect = .zero
    var body: some View {
        let status = activeTab == .home || activeTab == .search
        
        HStack(spacing: !status ? 0 : 12) {
            HStack(spacing: 0) {
                
                ForEach(TabModel.allCases, id: \.rawValue) { tab in
                    Button {
                        activeTab = tab
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: tab.rawValue)
                                .font(.title3)
                                .frame(width: 30, height: 30)
                            
                            if activeTab == tab {
                                Text(tab.title)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }
                        }
                        .foregroundStyle(activeTab == tab ? activeForeground : .gray)
                        .padding(.vertical, 2)
                        .padding(.leading, 10)
                        .padding(.trailing, 15)
                        .contentShape(.rect)
                        .background {
                            if activeTab == tab {
                                Capsule()
                                    .fill(.clear)
                                    .onGeometryChange(for: CGRect.self, of: {
                                        $0.frame(in: .named("TABBARVIEW"))
                                    }, action: { newValue in
                                        tabLocation = newValue
                                    })
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(alignment: .leading) {
                Capsule()
                    .fill(activeBackground.gradient)
                    .frame(width: tabLocation.width, height: tabLocation.height)
                    .offset(x: tabLocation.minX)
            }
            .coordinateSpace(.named("TABBARVIEW"))
            .padding(.horizontal, 5)
            .frame(height: 45)
            .background(
                .background
                    .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
                    .shadow(.drop(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)),
                in: .capsule
            )
            .zIndex(10)
            
            MorphingSymbolView(
                symbol: activeTab == .home ? "house.fill" : "line.3.horizontal.decrease",
                config: .init(
                    font: .title3.bold(),
                    frame: .init(width: 42, height: 42),
                    radius: 5,
                    foregroundColor: activeForeground,
                    keyFrameDuration: 0.3,
                    symbolAnimation: .smooth(duration: 0.35, extraBounce: 0)
                )
            )
            .background(activeBackground.gradient)
            .clipShape(.circle)
            
            .allowsHitTesting(status)
            .offset(x: status ? 0 : -20)
            .padding(.leading, status ? 0 : -42)
        }
        .padding(.bottom, 10)
        .animation(.smooth(duration: 0.3, extraBounce: 0), value: activeTab)
        .frame(maxWidth: .infinity)
        
    }
}

/// Custom Symobol Morphing View
struct MorphingSymbolView: View {
    var symbol: String
    var config: Config
    /// View Properties
    @State private var trigger: Bool = false
    @State private var displayingSymbol: String = ""
    @State private var nextSymbol: String = ""
    var body: some View {
        Canvas { ctx, size in
            ctx.addFilter(.alphaThreshold(min: 0.4, color: config.foregroundColor))
            
            if let renderedImage = ctx.resolveSymbol(id: 0) {
                ctx.draw(renderedImage, at: CGPoint(x: size.width / 2, y: size.height / 2))
            }
        } symbols: {
            ImageView()
                .tag(0)
        }
        .frame(width: config.frame.width, height: config.frame.height)
        .onChange(of: symbol) { oldValue, newValue in
            trigger.toggle()
            nextSymbol = newValue
        }
        .task {
            guard displayingSymbol == "" else { return }
            displayingSymbol = symbol
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        KeyframeAnimator(initialValue: CGFloat.zero, trigger: trigger) { radius in
            Image(systemName: displayingSymbol == "" ? symbol : displayingSymbol)
                .font(config.font)
                .blur(radius: radius)
                .frame(width: config.frame.width, height: config.frame.height)
                .onChange(of: radius) { oldValue, newValue in
                    if newValue.rounded() == config.radius {
                        /// Animating Symbol Change
                        withAnimation(config.symbolAnimation) {
                            displayingSymbol = nextSymbol
                        }
                    }
                }
        } keyframes: { _ in
            CubicKeyframe(config.radius, duration: config.keyFrameDuration)
            CubicKeyframe(0, duration: config.keyFrameDuration)
        }
    }
    
    struct Config {
        var font: Font
        var frame: CGSize
        var radius: CGFloat
        var foregroundColor: Color
        var keyFrameDuration: CGFloat = 0.4
        var symbolAnimation: Animation = .smooth(duration: 0.5, extraBounce: 0)
    }
}

#Preview {
    MorphingSymbolView(symbol: "gearshape.fill", config: .init(font: .system(size: 100, weight: .bold), frame: CGSize(width: 250, height: 200), radius: 15, foregroundColor: .black))
}



struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Floating Tab Bar")
                .background(Color.primary.opacity(0.07))
            /// To Cover the floating tab bar
                .safeAreaPadding(.bottom, 60)
        }
    }
}
/// A Helper View to hide tab bar in iOS 17 Devices.
struct HideTabBar: UIViewRepresentable {
    init(result: @escaping () -> Void) {
        UITabBar.appearance().isHidden = true
        self.result = result
    }
    
    var result: () -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                UITabBar.appearance().isHidden = false
                tabController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {  }
}

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        
        return nil
    }
}



struct AnimatedBLoader: View {
    @State private var isAnimating = false
    @State private var loadingDone = false
    
    let duration: TimeInterval = 5.0  // Total loading duration in seconds
    
    var body: some View {
        ZStack {
            if loadingDone {
                Text("Loading Complete!")
                    .font(.headline)
            } else {
                Text("B")
                    .font(.system(size: 60, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.accentColor, .accentColor], startPoint: .top, endPoint: .bottom)
                    )
                    .scaleEffect(isAnimating ? 1.1 : 0.8)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                loadingDone = true
                            }
                        }
                    }
            }
        }
    }
}
#Preview {
    AnimatedBLoader()
}
