//
//  Home.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct MoneyRequest: Codable {
    var requestId: String
    var fromUserId: String
    var toUserId: String
    var amount: Double
    var status: String // "pending", "approved", "rejected"
}

struct Home: View {
    @StateObject private var navigationState = NavigationState()
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var homeVM: HomeVM
    @State private var showBalance: Bool = false
    @State private var viewALL: Bool = false
    @State private var selection: selection = .financial
    @State private var transactionType: TransactionType = .sendMoney
    @State private var showTrnsactionType: Bool = false
    @State private var detentHeight: CGFloat = 0
    @State private var showStatements: Bool = false
    @State private var showNotifications: Bool = false
    @State private var showSpending: Bool = false
    @State var mainAction: MainAction = .send(.sendMoney)
    @State private var showProfile: Bool = false
    @State private var showStats: Bool = false
    
    @AppStorage("requestSent") var requestSent: Bool = false
    
    var user: UserModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack {
                    ScrollView {
                        HomeHeaderView(
                            homeVM: homeVM,
                            showProfile: $showProfile,
                            showStats: $showStats,
                            showBalance: $showBalance,
                            showTrnsactionType: $showTrnsactionType,
                            transactionType: $transactionType,
                            detentHeight: $detentHeight,
                            showStatements: $showStatements
                        )
                        
                        ImageCarousel()
                        
                        HomeServicesView(viewALL: $viewALL, selection: $selection)
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.horizontal, 6)
                .environmentObject(navigationState)
                .onChange(of: navigationState.shouldNavigateToHome) { _ , newValue in
                    if newValue {
                        let window = UIApplication.shared.connectedScenes
                            .filter { $0.activationState == .foregroundActive }
                            .compactMap { $0 as? UIWindowScene }
                            .first?.windows
                            .filter { $0.isKeyWindow }.first
                        
                        if let window = window {
                            window.rootViewController?.dismiss(animated: true)
                        }
                    }
                }
                .sheet(isPresented: $viewALL, content: {
                    ServiceSheet(title: "", selection: selection)
                })
                .sheet(isPresented: $showTrnsactionType,
                       content: {
                    TransactionButtonPressed(
                        detentHeight: $detentHeight,
                        transactionType: $transactionType,
                        mainAction: mainAction
                    )
                    .environmentObject(navigationState)
                })
                .sheet(isPresented: $homeVM.requestState, content: {
                    IncomingRequest(name: "John doe", amount: 500) {
                        Task {
                            try await DatabaseService.instance.approveRequest(receiverPhoneNumber: "+12345678999", sendersPhoneNumber: "+15555648583")
                        }
                    }
                    .presentationDetents([.fraction(0.4)])
                })
                .navigationDestination(isPresented: $showStatements) {
                    Statements()
                        .navigationBarBackButtonHidden()
                }
                .navigationDestination(isPresented: $showProfile) {
                    Profile(user: user)
                        .navigationBarBackButtonHidden()
                }
                .sheet(isPresented: $showStats, content: {
                    Stats()
                })
                .onAppear {
                    Task {
                        _ = try await DatabaseService.instance.fetchTransactionHistory()
                        await homeVM.fetchUserDetails()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.bouncy) {
                            requestSent = false
                        }
                    }
                    
                    navigationState.shouldNavigateToHome = false
                }
                .refreshable {
                    Task {
                        await homeVM.fetchUserDetails()
                        await homeVM.fetchTransactionHistory()
                    }
                }
                
                if requestSent {
                    Text("Request sent ✅")
                        .foregroundStyle(.kibetiGreen)
                        .offset(y: 170)
                }
            }
        }
    }
}

#Preview {
    Home(homeVM: HomeVM(), user: UserModel(firstName: "Dominic", lastName: "Aisak", phoneNumber: "12345678", kibetiBalance: 0))
}
