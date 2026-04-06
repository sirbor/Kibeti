//
//  AccountBalance.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import Foundation
import SwiftUI

@MainActor
final class KibetiBalance: ObservableObject {
    @AppStorage("userLoggedIn") private var userLoggedIn: Bool = false
    static let instance = KibetiBalance()
    private let mshwariBalanceKey = "mshwariAmount"
    private let loanKey = "keyLoan"
    
    @Published var mshwariBalance: Double = 0 {
        didSet {
            saveMshwariBalance()
        }
    }
    
    @Published var loanBalance: Double = 0 {
        didSet {
            saveLoanBalance()
        }
    }
    
    private init() {
        loadBalances()
    }


    private func loadBalances() {
        if let data = UserDefaults.standard.data(forKey: mshwariBalanceKey),
           let decoded = try? JSONDecoder().decode(Double.self, from: data) {
            mshwariBalance = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: loanKey),
           let decoded = try? JSONDecoder().decode(Double.self, from: data) {
            loanBalance = decoded
        }
    }
    
    private func saveMshwariBalance() {
        if let encoded = try? JSONEncoder().encode(mshwariBalance) {
            UserDefaults.standard.set(encoded, forKey: mshwariBalanceKey)
        }
    }
    
    private func saveLoanBalance() {
        if let encoded = try? JSONEncoder().encode(loanBalance) {
            UserDefaults.standard.set(encoded, forKey: loanKey)
        }
    }
    
    func deductKibetiBalanceAddToMshwari(depositAmount: Double) async {
        do {
            var balance = try await DatabaseService.instance.fetchUserDetails().kibetiBalance
            balance -= depositAmount
            try await DatabaseService.instance.updateUserBalance(newBalance: balance)
            mshwariBalance += depositAmount
        } catch {
            print("Error deducting amount")
        }
    }
    
    func deductMshwariBalanceAddToKibeti(withdrawAmount: Double) async {
        do {
            try await DatabaseService.instance.addUserBalance(newAmount: withdrawAmount)
            mshwariBalance -= withdrawAmount
        } catch {
            print("Error adding amount from mshwari")
        }
    }
    
    func addLoanAmountToKibetiBalance(loanAmount: Double) async {
        do {
            try await DatabaseService.instance.addUserBalance(newAmount: loanAmount)
            loanBalance = loanBalance + loanAmount
        } catch {
            print("Error adding loan amount to balance")
        }
    }
    
    func payLoan(amount: Double) async {
        loanBalance = loanBalance - amount
        do {
            try await DatabaseService.instance.deductUserBalance(newAmount: amount)
        } catch {
            print("Error when paying loan")
        }
    }
}
