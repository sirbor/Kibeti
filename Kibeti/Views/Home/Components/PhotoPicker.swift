//
//  PhotoPicker.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI
import PhotosUI


struct PhotoPicker: View {
    var body: some View {
        Image("profile")
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
//            .frame(width: 100, height: 100)
    }
}

#Preview {
    PhotoPicker()
}
