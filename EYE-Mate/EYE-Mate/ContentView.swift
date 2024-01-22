//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct ContentView: View {
    @State var str = ""
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .font(.pretendardSemiBold16)
            
            TextField("Enter your email", text: $str)
                .padding()
                .background(Color.textFieldGray)
            
            Text("Email \(str)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
