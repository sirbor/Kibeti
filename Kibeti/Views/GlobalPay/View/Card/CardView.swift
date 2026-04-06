//
//  CardView.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct CardView: View {
    @ObservedObject var globalVM: GlobalVM
    
    // used for rotation
    @Binding var frontDegree: Double
    @Binding var backDegree: Double
    
    var body: some View {
        ZStack {
            CardFront(globalVM: globalVM, degree: $frontDegree)
            CardBack(globalVM: globalVM, degree: $backDegree)
        }
    }
}

//#Preview {
////    CardView(globalVM: GlobalVM(), showCardDetails: .constant(true))
//}



