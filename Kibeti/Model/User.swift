//
//  User.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

struct UserModel: Codable {
    @DocumentID var id: String?
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var imageURL: String?
    var image: UIImage?
    var kibetiBalance: Double
    
    init(firstName: String, lastName: String, phoneNumber: String, imageURL: String? = nil, image: UIImage? = nil, kibetiBalance: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.imageURL = imageURL
        self.image = image
        self.kibetiBalance = kibetiBalance
    }

    enum CodingKeys: CodingKey {
        case id
        case firstName
        case lastName
        case phoneNumber
        case imageURL
        case kibetiBalance
    }
}
