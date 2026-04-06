//
//  FundsOriginPath.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import SwiftUI

struct FundsOriginPath: View {
    @Environment(\.dismiss) var dismiss
    @State private var origin: FundsOrigin = .kibeti
    @State var reqPay: ReqPayPath = .pay
    @State private var navigate: Bool = false
    @State private var isKibeti: Bool = false
    
    var amount: Double
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Image(systemName: "arrow.left")
                    .font(.title3)
                    .padding(.top, 20)
                    .onTapGesture {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("PAY LOAN")
                    .font(.title)
                    .fontWeight(.light)
                    .padding(.top, 40)
                
                Text("CHOOSE FUNDS ORIGIN")
                    .font(.subheadline)
                    .fontWeight(.light)
                
                VStack (spacing: 20){
                    HStack {
                        Image("airtime")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.kibetiGreen)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(.kibetiGreen, lineWidth: 1.0)
                                    .frame(width: 50, height: 50)
                            }
                        
                        Text("Kibeti")
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                        
                        Image(systemName: "greaterthan")
                    }
                    .padding(10)
                    .background(.white)
                    .cornerRadius(6)
                    .shadow(radius: 2)
                    .onTapGesture {
                        isKibeti = true
                        navigate.toggle()
                        self.origin = .kibeti
                    }
                    
                    
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.kibetiGreen)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("M-SHWARI")
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Spacer()
                        Image(systemName: "greaterthan")
                    }
                    .padding(10)
                    .background(.white)
                    .cornerRadius(6)
                    .shadow(radius: 2)
                    .onTapGesture {
                        isKibeti = false
                        navigate.toggle()
                        self.origin = .mshwari
                    }
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .navigationDestination(isPresented: $navigate) {
                ConfirmReqPay(reqPayPath: reqPay, loanAmount: amount, isKibeti: isKibeti)
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    FundsOriginPath(amount: 0)
}
