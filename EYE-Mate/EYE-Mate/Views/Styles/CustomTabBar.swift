//
//  CustomTabBar.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/10.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    let content: Content
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = [.home, .movement, .community, .eyeMap]
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
            CustomTabBar(tabs: tabs, localSelection: selection, selection: $selection)
        }
        .onPreferenceChange(TabBarItemPrefrenceKey.self, perform: { value in
            self.tabs = tabs
        })
        .ignoresSafeArea(edges: .bottom)
    }
}

//MARK: - Custom 탭바
struct CustomTabBar: View {
    let tabs: [TabBarItem]
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    @Binding var selection: TabBarItem
    
    var body: some View {
        tabBarVersion
            .onChange(of: selection) { newValue in
                withAnimation(.bouncy) {
                    localSelection = newValue
                }
            }
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
                .scaleEffect(selection == tab ? 1.4 : 1.0)
                
            Text(tab.title)
                .scaleEffect(selection == tab ? 1.2 : 1.0)
                .font(.pretendardMedium_10)
        }
        .foregroundColor(localSelection == tab ? Color.customGreen : Color.gray)
        .animation(.interpolatingSpring(stiffness: 300, damping: 10), value: selection)
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
        selection = tab
    }
    
    private func switchToTabWithAnimation(tab: TabBarItem) {
        withAnimation(.easeInOut) {
            selection = tab
        }
    }
}


//MARK: - PreferenceKey
struct TabBarItemPrefrenceKey: PreferenceKey {
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
            .preference(key: TabBarItemPrefrenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}
