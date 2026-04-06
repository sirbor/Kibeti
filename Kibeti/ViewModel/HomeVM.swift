//
//  HomeVM.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class HomeVM: ObservableObject {
    @Published var kibetiBalance: Double = 0
    @Published var username: String = ""
    @Published var transactions: [Transaction] = []
    @Published var requestState: Bool = false

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }

    private var listener: ListenerRegistration?
    
    private var isFirebaseConfigured: Bool {
        FirebaseApp.allApps?.keys.contains("__FIRAPP_DEFAULT") ?? false
    }
    
    init() {
        Task {
            await fetchUserDetails()
            await fetchTransactionHistory()
            if isFirebaseConfigured {
                startListeningForRequestState()
            }
        }
    }
    
    deinit {
        stopListening()
    }
    
    func fetchUserDetails() async {
        do {
            let user = try await DatabaseService.instance.fetchUserDetails()
            
            await MainActor.run {
                self.kibetiBalance = user.kibetiBalance
                self.username = user.firstName
            }
        } catch {
            print("Error fetching user details: \(error)")
        }
    }
    
    func fetchTransactionHistory() async {
        do {
            let transactions = try await DatabaseService.instance.fetchTransactionHistory()
            await MainActor.run {
                self.transactions = transactions.sorted { $0.date > $1.date }
            }
        } catch {
            print("Error fetching transaction history: \(error)")
        }
    }
    
    private func startListeningForRequestState() {
        guard isFirebaseConfigured else { return }
        Task {
            let uid = await DatabaseService.instance.getCurrentUserID()
            let db = Firestore.firestore()
            
            listener = db.collection("requestState").document(uid).addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist")
                    return
                }
                
                if let data = document.data() {
                    let status = data["requestStatus"] as? Bool ?? false
                    DispatchQueue.main.async {
                        self.requestState = status
                        print("Real-time request status: \(status)")
                    }
                }
            }
        }
    }
    
    private func stopListening() {
        listener?.remove()
        listener = nil
    }

    // Helper to fetch images (can be moved to a Service later)
    private func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Image download failed", code: 0, userInfo: nil)
        }
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
        }
        return image
    }
}
