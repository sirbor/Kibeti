//
//  MainAction.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import Foundation

enum MainAction {
    case send(SendAction)
    case pay(PayAction)
    case withdraw(WithdrawAction)
    case airtime(AirtimeAction)

    enum SendAction {
        case sendMoney
        case requestMoney
        case global
        case scanQr
    }

    enum PayAction {
        case payBill
        case buyGoods
        case pochi
        case globalPay
    }

    enum WithdrawAction {
        case withdraw
        case withdrawAtATM
        case scanQr
    }

    enum AirtimeAction {
        case buyForMyNumber
        case buyForOtherNumber
        case buyBundles
    }
}
