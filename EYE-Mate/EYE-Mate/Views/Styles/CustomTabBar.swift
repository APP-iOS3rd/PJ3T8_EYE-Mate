//
//  CustomTabBar.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/10.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    let content: Content
    @EnvironmentObject var tabManager: TabManager
    @State private var tabs: [TabBarItem] = [.home, .movement, .community, .eyeMap]
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
            CustomTabBar(tabs: tabs, localSelection: tabManager.selection)
        }
        .onPreferenceChange(TabBarItemPreferenceKey.self, perform: { value in
            print("onPreferenceChange called : \(tabs)")
            self.tabs = tabs
        })
        .ignoresSafeArea(edges: .bottom)
    }
}

//MARK: - Custom 탭바
struct CustomTabBar: View {
    let tabs: [TabBarItem]
    @Namespace private var namespace
    @EnvironmentObject var tabManager: TabManager
    @State var localSelection: TabBarItem
    
    var body: some View {
        tabBarVersion
            .onChange(of: tabManager.selection) { newValue in
                localSelection = newValue
            }
            .animation(.bouncy, value: localSelection)
    }
}

extension CustomTabBar {
    private var tabBarVersion: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .padding(.horizontal, 6)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack(spacing: 5) {
            Image(systemName: tab.iconName)
                .scaleEffect(tabManager.selection == tab ? 1.4 : 1.0)
                
            Text(tab.title)
                .scaleEffect(tabManager.selection == tab ? 1.2 : 1.0)
                .font(.pretendardMedium_10)
        }
        .foregroundColor(localSelection == tab ? Color.customGreen : Color.gray)
        .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: tabManager.selection)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.customGreen.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
        .padding(.bottom, 20)
    }
}

//MARK: - Method
extension CustomTabBar {
    private func switchToTab(tab: TabBarItem) {
        HapticManager.instance.impact(style: .light)
        tabManager.selection = tab
    }
    
    private func switchToTabWithAnimation(tab: TabBarItem) {
        withAnimation(.easeInOut) {
            tabManager.selection = tab
        }
    }
}


//MARK: - PreferenceKey
struct TabBarItemPreferenceKey: PreferenceKey {
    static var defaultValue = [TabBarItem]()
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

//MARK: - Modifier
struct TabBarItemViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}
