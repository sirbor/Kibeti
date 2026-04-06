//
//  RandomID.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import Foundation


final class RandomID {
    static let shared = RandomID()
    
    func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<11).map{ _ in letters.randomElement()! }).uppercased()
    }
}
