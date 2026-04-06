//
//  HomeServicesView.swift
//  Kibeti
//

import SwiftUI

struct HomeServicesView: View {
    @Binding var viewALL: Bool
    @Binding var selection: selection
    
    var body: some View {
        VStack(spacing: 24) {
            financialServices
            shopAndGift
            publicSector
            getInsurance
            transportAndTravel
            rewardAndLoyalty
            healthAndWellness
            eventsAndExpiriences
            mySafaricom
            education
            newsAndEntertainment
            
            Rectangle()
                .fill(.clear)
                .frame(height: 20)
        }
    }
    
    private var financialServices: some View {
        RoundedView(
            componentTitle: "Financial Services",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                viewALL.toggle()
                selection = .financial
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "MǍLI",
                        title: "MALI",
                        textColor: .white,
                        backgroundColor: .kibetiGreen,
                        imageName: "",
                        isText: true
                    )
                    
                    NavigationLink {
                        MshwariView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        RoundedComponent(
                            imageText: "M-Shwari",
                            title: "M-SHWARI",
                            textColor: .white,
                            backgroundColor: .gray,
                            imageName: "",
                            isText: true
                        )
                    }
                    .tint(.primary)
                    
                    
                    RoundedComponent(
                        imageText: "KCB",
                        title: "KCB Kibeti",
                        textColor: .white,
                        backgroundColor: .blue,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "RATIBA",
                        title: "Kibeti RATIBA",
                        textColor: .white,
                        backgroundColor: .kibetiGreen,
                        imageName: "",
                        isText: true
                    )
                }
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var shopAndGift: some View {
        RoundedView(
            componentTitle: "Shop & Gift",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                viewALL.toggle()
                selection = .shop
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "GiftPesa",
                        title: "Buy Gift",
                        textColor: .white,
                        backgroundColor: .red,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "MAJi",
                        title: "MAJIAPP",
                        textColor: .blue,
                        backgroundColor: .gray.opacity(0.4),
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "ezawadi",
                        title: "EZAWADI",
                        textColor: .white,
                        backgroundColor: .pink,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "M-SOKO",
                        title: "Safaricom M-soko",
                        textColor: .white,
                        backgroundColor: .kibetiGreen,
                        imageName: "",
                        isText: true
                    )
                }
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var publicSector: some View {
        RoundedView(
            componentTitle: "Public Sector",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                viewALL.toggle()
                selection = .publicSector
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "MYCOUNTY",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "kenya",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "MYNAIROBI",
                        textColor: .white,
                        backgroundColor: .primary,
                        imageName: "nairobi",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "Hustler Fund",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "hustler",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "NHIF",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "nhif",
                        isText: false
                    )
                }
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var getInsurance: some View {
        RoundedView(
            componentTitle: "Get Insurance",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "Marine Cargo",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "cruise",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "PRUDENTIAL",
                        title: "PRUDENTIAL",
                        textColor: .red,
                        backgroundColor: .gray.opacity(0.4),
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "Insureme",
                        title: "INSUREME",
                        textColor: .white,
                        backgroundColor: .pink,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "Kenbright",
                        title: "Kenbright",
                        textColor: .orange,
                        backgroundColor: .blue,
                        imageName: "",
                        isText: true
                    )
                }
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var transportAndTravel: some View {
        RoundedView(
            componentTitle: "Transport & Travel",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                // pass selection type and view all click
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "BOOK A FLIGHT",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "airplane",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "TRIPS",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "trips",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "SGR",
                        textColor: .primary,
                        backgroundColor: .pink,
                        imageName: "sgr",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "IABIRI APP",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "bus",
                        isText: false
                    )
                }
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var rewardAndLoyalty: some View {
        RoundedView(
            componentTitle: "Reward & Loyalty",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                // pass selection type and view all click
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "SHell club",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "shell",
                        isText: false
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var healthAndWellness: some View {
        
        RoundedView(
            componentTitle: "Health & Awareness",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                // pass selection type and view all click
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "MDAKTARI",
                        textColor: .red,
                        backgroundColor: .primary,
                        imageName: "nurse",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "Prudential",
                        title: "Prudential",
                        textColor: .primary,
                        backgroundColor: .gray,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "HEALTH INSURANCE",
                        textColor: .primary,
                        backgroundColor: .gray,
                        imageName: "heart",
                        isText: false
                    )
                    
                    
                    RoundedComponent(
                        imageText: "",
                        title: "SASADOCTOR",
                        textColor: .primary,
                        backgroundColor: .gray,
                        imageName: "healthcare",
                        isText: false
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var eventsAndExpiriences: some View {
        
        RoundedView(
            componentTitle: "Events & Expiriences",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                // pass selection type and view all click
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "anga",
                        title: "movies",
                        textColor: .black,
                        backgroundColor: .gray,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "mookh",
                        title: "MOOKH",
                        textColor: .white,
                        backgroundColor: .yellow,
                        imageName: "",
                        isText: true
                    )
                    
                    RoundedComponent(
                        imageText: "team",
                        title: "TEAM TRAVEL",
                        textColor: .red,
                        backgroundColor: .gray.opacity(0.2),
                        imageName: "",
                        isText: true
                    )
                    
                    
                    RoundedComponent(
                        imageText: "malipo",
                        title: "MALIPOEXPERIENC",
                        textColor: .white,
                        backgroundColor: .pink,
                        imageName: "",
                        isText: true
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 52)
                .padding(12)
            }
        
    }
    
    private var mySafaricom: some View {
        
        RoundedView(
            componentTitle: "My Safaricom",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                viewALL.toggle()
                selection = .mySaf
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "Kibeti RATIBA",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "calendar",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "SAFARICOM BUNDLES",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "logo",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "",
                        title: "ask zuri",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "assistant",
                        isText: false
                    )
                    
                    
                    RoundedComponent(
                        imageText: "M-SOKO",
                        title: "SAFARICOM M-SOKO",
                        textColor: .white,
                        backgroundColor: .kibetiGreen,
                        imageName: "",
                        isText: true
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var education: some View {
        
        RoundedView(
            componentTitle: "Education",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                // pass selection type and view all click
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "",
                        title: "helb",
                        textColor: .primary,
                        backgroundColor: .primary,
                        imageName: "helb",
                        isText: false
                    )
                    
                    RoundedComponent(
                        imageText: "Kodris",
                        title: "KODRIS AFRICA",
                        textColor: .primary,
                        backgroundColor: .orange,
                        imageName: "",
                        isText: true
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 52)
                .padding(12)
            }
    }
    
    private var newsAndEntertainment: some View {
        RoundedView(
            componentTitle: "Education",
            height: 165,
            viewALL: $viewALL,
            selection: $selection) {
                // pass selection type and view all click
            }
            .overlay {
                HStack(alignment: .top, spacing: 22) {
                    RoundedComponent(
                        imageText: "the standard",
                        title: "THE STANDARD",
                        textColor: .red,
                        backgroundColor: .white,
                        imageName: "",
                        isText: true
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 52)
                .padding(12)
            }
    }
}
