//
//  MshwariLoading.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct MshwariLoading: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color("mshwariColor")
                .ignoresSafeArea()
            
            Image("mshwari")
                .resizable()
                .scaledToFit()
                .offset(y: -40)
            
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.white.opacity(0.7))
                    .frame(width: 100, height: 30)
                    .overlay {
                        HStack {
                            Image(systemName: "ellipsis")
                            Spacer()
                            Image(systemName: "xmark.circle")
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                        .padding(.horizontal, 14)
                        .fontWeight(.medium)
                    }
            }
            .foregroundStyle(.black)
            .padding(.trailing)
            .frame(maxHeight: .infinity, alignment: .topTrailing)
            
            
            ProgressView()
                .tint(.black)
            
        }
    }
}

#Preview {
    MshwariLoading()
}
