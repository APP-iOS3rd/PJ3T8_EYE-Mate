//
//  ToastModifier.swift
//  EYE-Mate
//
//  Created by seongjun on 1/25/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: 30)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast, perform: { _ in
                showToast()
            })
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if toast != nil {
            VStack {
                ToastView() {
                    dismissToast()
                }
                Spacer()
            }
            .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity.animation(.easeInOut)))
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}
