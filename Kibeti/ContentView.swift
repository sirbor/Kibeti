//
//  ContentView.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

extension Color {
    static let kibetiGreen = Color(red: 193/255, green: 255/255, blue: 114/255)
}

extension ShapeStyle where Self == Color {
    static var kibetiGreen: Color { .kibetiGreen }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
