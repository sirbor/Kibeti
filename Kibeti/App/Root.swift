//
//  Root.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct Root: View {
    @AppStorage("userLoggedIn") var userLoggedIn: Bool = false
    let user = UserModel(firstName: "Dominic", lastName: "Aisak", phoneNumber: "12345678", kibetiBalance: 0)
    
    var body: some View {
        ZStack {
            if userLoggedIn {
                // show main view
                MainTab(user: user)
            } else {
                // show login view
                Register()
            }
        }
    }
}

#Preview {
    Root()
}
