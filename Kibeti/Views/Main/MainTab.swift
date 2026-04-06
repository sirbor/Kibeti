//
//  MainTab.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

@MainActor
class MainEntry: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var showPinView: Bool = false
    
    func authUser(reason: String) async {
        isUserAuthenticated = await LocalAuth.shared.authenticateWithBiometrics(reason: reason)
    }
}

struct MainTab: View {
    @StateObject private var vm = MainEntry()
    @StateObject private var homeVM = HomeVM() // Instantiating here for injection
    
    var user: UserModel
    
    var body: some View {
        ZStack {
            if vm.isUserAuthenticated {
                TabView {
                    Home(homeVM: homeVM, user: user)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    
                    TransactView()
                        .tabItem {
                            Label("Transact", systemImage: "arrow.left.arrow.right")
                        }
                    
                    ServicesView()
                        .tabItem {
                            Label("Services", systemImage: "list.triangle")
                        }
                    
                    Grow()
                        .tabItem {
                            Label("Grow", systemImage: "chart.bar.xaxis.ascending.badge.clock")
                        }
                }
                .environmentObject(homeVM)
                .tint(.kibetiGreen)
                .fontWeight(.bold)
            } else {
                Login(authState: $vm.isUserAuthenticated)
            }
        }
    }
}

#Preview {
    MainTab(user: UserModel(firstName: "Dominic", lastName: "Aisak", phoneNumber: "12345678", kibetiBalance: 0))
}
