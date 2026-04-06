//
//  HomeHeaderView.swift
//  Kibeti
//

import SwiftUI

struct HomeHeaderView: View {
    @ObservedObject var homeVM: HomeVM
    @Binding var showProfile: Bool
    @Binding var showStats: Bool
    @Binding var showBalance: Bool
    @Binding var showTrnsactionType: Bool
    @Binding var transactionType: TransactionType
    @Binding var detentHeight: CGFloat
    @Binding var showStatements: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            topView
            balanceView
                .padding(.bottom, 12)
            transactionButtons
                .padding(.bottom, 12)
            kibetiStatements
        }
    }
    
    // MARK: topView
    private var topView: some View  {
        HStack(spacing: 14) {
            PhotoPicker()
                .frame(width: 60, height: 60)
                .onTapGesture {
                    showProfile.toggle()
                }
            
            VStack(alignment: .leading) {
                Text(homeVM.greeting)
                    .fontWeight(.light)
                Text("\(homeVM.username) 👋")
                    .fontWeight(.heavy)
            }
            .padding(.leading, -18)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "bell")
                .imageScale(.large)
            
            Image(systemName: "chart.pie")
                .rotationEffect(Angle(degrees: -130))
                .imageScale(.large)
                .onTapGesture {
                    showStats.toggle()
                }
            
            Image(systemName: "qrcode.viewfinder")
                .imageScale(.large)
        }
    }
    
    // MARK: Balance view
    private var balanceView: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.15))
                .shadow(radius: 1)
                .frame(height: 120)
                .overlay {
                    ZStack(alignment: .top) {
                        Text("Balance")
                            .fontWeight(.light)
                            .padding(.top, 6)
                        
                        VStack(alignment: .center) {
                            Text("KSH. \(homeVM.kibetiBalance.formatted(.number.precision(.fractionLength(2)).grouping(.automatic)))")
                                .font(.title)
                                .fontWeight(.light)
                            Text("Available FULIZA: KSH 31,000.00")
                                .fontWeight(.light)
                                .foregroundStyle(.blue)

                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .padding(.horizontal, 20)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .blur(radius: showBalance ? 6 : 0)
                    }
                    Image(systemName: showBalance ? "eye" : "eye.slash")
                        .offset(x: 140, y: -10)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                showBalance.toggle()
                            }
                        }
                }
        }
    }
    
    // MARK: Transaction buttons
    private var transactionButtons: some View {
        HStack(alignment: .top, spacing: 24) {
            transactionButton(title1: "SEND AND ", title2: "REQUEST", icon: "arrow.left.arrow.right", color: "sendColor", type: .sendMoney, isSystemIcon: true)
            transactionButton(title1: "PAY", title2: "", icon: "pay", color: "payColor", type: .pay)
            transactionButton(title1: "WITHDRAW", title2: "", icon: "withdraw", color: "withdrawColor", type: .withdraw)
            transactionButton(title1: "AIRTIME", title2: "", icon: "airtime", color: "airtimeColor", type: .airtime)
        }
        .font(.subheadline)
        .fontWeight(.light)
    }
    
    @ViewBuilder
    private func transactionButton(title1: String, title2: String, icon: String, color: String, type: TransactionType, isSystemIcon: Bool = false) -> some View {
        VStack(alignment: .center) {
            if isSystemIcon {
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .rotationEffect(Angle(degrees: icon == "arrow.left.arrow.right" ? -50 : 0))
                    .padding(10)
                    .background(Color(color))
                    .clipShape(Circle())
            } else {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .padding(10)
                    .background(Color(color))
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
            }
            
            Text(title1)
            if !title2.isEmpty {
                Text(title2)
            }
        }
        .onTapGesture {
            showTrnsactionType.toggle()
            transactionType = type
            self.detentHeight = getDetentHeight(type)
        }
    }
    
    func getDetentHeight(_ transaction: TransactionType) -> CGFloat {
        switch transaction {
        case .sendMoney: return 0.45
        case .pay: return 0.55
        case .withdraw: return 0.4
        default: return 0.4
        }
    }
    
    // MARK: Statements
    private var kibetiStatements: some View {
        Group {
            HStack(alignment: .top, spacing: 6) {
                Text("Kibeti STATEMENTS")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("SEE ALL")
                    .foregroundStyle(.kibetiGreen)
                    .font(.headline)
                    .onTapGesture {
                        showStatements.toggle()
                    }
            }
            
            if let latestTransaction = homeVM.transactions.first {
                HStack {
                    Circle()
                        .fill(.kibetiGreen.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay {
                            Text("\(latestTransaction.contact?.familyName.prefix(1) ?? "")\(latestTransaction.contact?.givenName.prefix(1) ?? "")")
                                .foregroundStyle(.kibetiGreen)
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(latestTransaction.contact?.familyName ?? "") \(latestTransaction.contact?.givenName ?? "")")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(latestTransaction.contact?.mobileNumber ?? latestTransaction.phoneNumber ?? "")
                            .foregroundStyle(.gray)
                            .fontWeight(.light)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("-KSH. \(latestTransaction.amount.formatted(.number.precision(.fractionLength(2)).grouping(.automatic)))")
                            .fontWeight(.light)
                        Text(latestTransaction.date.formatted(date: .abbreviated, time: .shortened))
                            .foregroundStyle(.gray)
                            .fontWeight(.light)
                    }
                }
                .blur(radius: showBalance ? 6 : 0)
            }  else {
                Text("No transactions available")
                    .foregroundStyle(.gray)
                    .fontWeight(.light)
            }
        }
    }
}
