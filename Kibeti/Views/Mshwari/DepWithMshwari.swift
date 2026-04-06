//
//  DepWithMshwari.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct DepWithMshwari: View {
    @EnvironmentObject var navState: MshwariNavigationState
    @EnvironmentObject var homeVM: HomeVM
    @ObservedObject var savings = KibetiBalance.instance
    @State private var amount: Double = 0
    @FocusState var amountFocus: Bool
    var isDeposit: Bool = false
    
    @Binding var deposit: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "xmark.circle")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    deposit.toggle()
                }
                .padding(.horizontal)
            
            Text(isDeposit ? "DEPOSIT FROM Kibeti" : "WITHDRAW TO Kibeti")
                .fontWeight(.light)
                .padding(.top, 60)
            
            HStack {
                Text("KSH.")
                TextField("", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                    .focused($amountFocus)
            }
            .offset(x: 160)
            .font(.title)
            .foregroundStyle(.primary)
            .padding(.top, 60)
            
            if !isDeposit {
                Text("SAVINGS BALANCE KSH: \( savings.mshwariBalance.formatted(.number.precision(.fractionLength(2)).grouping(.automatic)))")
                    .fontWeight(.light)
            } else {
                Text("Kibeti BALANCE KSH: \( homeVM.kibetiBalance .formatted(.number.precision(.fractionLength(2)).grouping(.automatic)))")
                    .fontWeight(.light)
            }
            
            Text("CONTINUE")
                .foregroundStyle(.black)
                .font(.headline)
                .padding()
                .padding(.horizontal, 80)
                .background(amount < 5 ? .white : .kibetiGreen)
                .clipShape(Capsule())
                .shadow(radius: 2)
                .onTapGesture {
                    Task.init {
                        let result = await LocalAuth.shared.authenticateWithBiometrics(reason: "Biometrics needed to deposit to savings")
                        if result {
                            if isDeposit {
                                await savings.deductKibetiBalanceAddToMshwari(depositAmount: amount)
                                deposit.toggle()
                                navState.navigateToRoot = true
                            } else {
                                await savings.deductMshwariBalanceAddToKibeti(withdrawAmount: amount)
                                deposit.toggle()
                                navState.navigateToRoot = true
                            }
                        }
                    }
                }
            
            Spacer()
        }
        .onAppear(perform: {
            amountFocus = true
        })
    }
}

#Preview {
    DepWithMshwari(deposit: .constant(true))
        .environmentObject(HomeVM())
}
