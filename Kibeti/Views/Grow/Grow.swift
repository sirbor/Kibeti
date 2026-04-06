//
//  Grow.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct Grow: View {
    @State private var mshwari: Bool = false
    @State private var globalPay: Bool = false
    
    
    var column: [GridItem] = [
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil),
        GridItem(.flexible(), spacing: nil, alignment: nil)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                ScrollView(.horizontal) {
                    HStack {
                        GrowComponent(title: "GLOBAL PAY", subtitle: "The World is yours")
                            .onTapGesture {
                                
                                Task {
                                    self.globalPay = await LocalAuth.shared.authenticateWithBiometrics(reason: "Biometrics needed")
                                }
                            }
                        GrowComponent(title: "MASHWARI", subtitle: "Go for it")
                            .onTapGesture {
                                mshwari.toggle()
                            }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 16)
                
                Text("DISCOVER MORE")
                    .font(.headline)
                LazyVGrid(columns: column, content: {
                    
                    RoundedComponent(
                        imageText: "M-SOKO",
                        title: "Safaricom M-soko",
                        textColor: .white,
                        backgroundColor: .kibetiGreen,
                        imageName: "",
                        isText: true
                    )
            
                    
                    RoundedComponent(
                        imageText: "",
                        title: "MYNAIROBI",
                        textColor: .white,
                        backgroundColor: .primary,
                        imageName: "logo",
                        isText: false
                        )

                        RoundedComponent(
                        imageText: "B",
                        title: "M-Shwari",
                        textColor: .primary,
                        backgroundColor: .kibetiGreen,
                        imageName: "logo",
                        isText: false
                        )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "NHIF",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "logo",
                        isText: false
                        )

                    RoundedComponent(
                        imageText: "B",
                        title: "M-Shwari",
                        textColor: .primary,
                        backgroundColor: .kibetiGreen,
                        imageName: "logo",
                        isText: false
                        )
                    
                    
                    RoundedComponent(
                        imageText: "mookh",
                        title: "MOOKH",
                        textColor: .white,
                        backgroundColor: .yellow,
                        imageName: "logo",
                        isText: false
                        )

                    RoundedComponent(
                        imageText: "B",
                        title: "M-Shwari",
                        textColor: .primary,
                        backgroundColor: .kibetiGreen,
                        imageName: "logo",
                        isText: false
                        )
              
                })
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("GROW")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $mshwari) {
                MshwariView()
                    .navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $globalPay) {
                GlobalPayView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    Grow()
}

struct GrowComponent: View {
    var title: String
    var subtitle: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
       RoundedRectangle(cornerRadius: 10.0)
            .fill(colorScheme == .dark ? .gray.opacity(0.3) : .black.opacity(0.1))
            .frame(width: 360, height: 250)
            .overlay(content: {
                VStack {
                    Image(systemName: "storefront")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .frame(height: 70)
                        .overlay {
                            HStack {
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                    Text(title)
                                    Text(subtitle)
                                }
                                .foregroundStyle(.primary)
                                
                                Spacer()
                            }
                        }
                        .clipShape(
                            .rect(
                                  topLeadingRadius: 0,
                                  bottomLeadingRadius: 10,
                                  bottomTrailingRadius: 10,
                                  topTrailingRadius: 0
                              )
                        )
                }
            })

    }
}
