//
//  DatabaseService.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class DatabaseService {
    static let instance = DatabaseService()
    
    private var isFirebaseConfigured: Bool {
        FirebaseApp.allApps?.keys.contains("__FIRAPP_DEFAULT") ?? false
    }
    
    func getCurrentUserID() async -> String {
        guard isFirebaseConfigured else {
            return "mock_user_id"
        }
        do {
            let result = try FirebaseAuth.instance.fetchAuthUser()
            return result.uid
        } catch {
            print("Error fetching current user")
            return "mock_user_id"
        }
    }
    
    func saveUserData(user: UserModel) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Skipping saveUserData.")
            return
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "firstName": user.firstName,
            "lastName": user.lastName,
            "phoneNumber": user.phoneNumber,
            "kibetiBalance": user.kibetiBalance
        ]
        // Save user data to Firestore
        try await db.collection("users").document(uid).setData(userData)
    }
    
    func saveRequestState() async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Skipping saveRequestState.")
            return
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        let userData: [String: Any] = ["requestStatus": false]
        // Save user data to Firestore
        try await db.collection("requestState").document(uid).setData(userData)
    }
    
    func fetchUserDetails() async throws -> UserModel {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Returning mock user details.")
            return UserModel(firstName: "Dominic", lastName: "Aisak", phoneNumber: "12345678", kibetiBalance: 345000.0)
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        let docSnapshot = try await db.collection("users").document(uid).getDocument()
        guard let data = docSnapshot.data() else {
            print("No data found")
            throw URLError(.badServerResponse)
        }
        
        let firstName = data["firstName"] as? String ?? ""
        let lastName = data["lastName"] as? String ?? ""
        let phoneNumber = data["phoneNumber"] as? String ?? ""
        let kibetiBalance = data["kibetiBalance"] as? Double ?? 0
        // imageURL is fetched but not currently used in the Model constructor
        
        return UserModel(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, kibetiBalance: kibetiBalance)
    }
    
    func saveTransactionHistory(transaction: Transaction) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Skipping saveTransactionHistory.")
            return
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        
        let transactionData: [String: Any] = [
            "phoneNumber": transaction.phoneNumber ?? "",
            "amount": transaction.amount,
            "date": transaction.date,
            "firstName": transaction.contact?.givenName ?? "",
            "lastName": transaction.contact?.familyName ?? ""
        ]
        
        try await db.collection("users").document(uid).collection("transactions").addDocument(data: transactionData)
    }
    
    func fetchTransactionHistory() async throws -> [Transaction] {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Returning empty transaction history.")
            return []
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        
        let snapshot = try await db.collection("users").document(uid).collection("transactions").getDocuments()
        
        var transactions: [Transaction] = []
        
        for document in snapshot.documents {
            let data = document.data()
            let phoneNumber = data["phoneNumber"] as? String ?? ""
            let amount = data["amount"] as? Double ?? 0
            let dateTimestamp = data["date"] as? Timestamp
            let date = dateTimestamp?.dateValue() ?? Date()
            let firstName = data["firstName"] as? String ?? ""
            let lastName = data["lastName"] as? String ?? ""
            
            let contact = Contact(givenName: firstName, familyName: lastName, mobileNumber: phoneNumber)
            let transaction = Transaction(contact: contact, phoneNumber: phoneNumber, date: date, amount: amount)
            transactions.append(transaction)
        }
        
        return transactions
    }
    
    func deductUserBalance(newAmount: Double) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating balance deduction.")
            return
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        
        // Fetch the current balance first
        let snapshot = try await db.collection("users").whereField("phoneNumber", isEqualTo: uid).getDocuments()
        guard let document = snapshot.documents.first else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        // Extract the user's current kibeti balance
        let data = document.data()
        guard let currentBalance = data["kibetiBalance"] as? Double else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "kibetiBalance not found"])
        }
        
        // Check if the current balance is sufficient to deduct the amount
        guard currentBalance >= newAmount else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insufficient balance"])
        }
        
        // Calculate the new kibeti balance after deduction
        let updatedBalance = currentBalance - newAmount
        
        // Update the user's kibeti balance in Firestore
        try await db.collection("users").document(document.documentID).updateData(["kibetiBalance": updatedBalance])
    }
    
    func updateUserBalance(newBalance: Double) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating balance update.")
            return
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        try await db.collection("users").document(uid).updateData(["kibetiBalance": newBalance])
    }
    
    func addUserBalance(newAmount: Double) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating add balance.")
            return
        }
        let uid = await getCurrentUserID()
        let db = Firestore.firestore()
        
        let docSnapshot = try await db.collection("users").document(uid).getDocument()
        guard let data = docSnapshot.data(), let currentBalance = data["kibetiBalance"] as? Double else {
            return
        }
        
        try await db.collection("users").document(uid).updateData(["kibetiBalance": currentBalance + newAmount])
    }
    
    func updateUserBalanceByPhoneNumber(phoneNumber: String, addAmount: Double) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating balance update.")
            return
        }
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Create a query to find the user with the given phone number
        let query = usersCollection.whereField("phoneNumber", isEqualTo: phoneNumber)
        
        // Execute the query
        let snapshot = try await query.getDocuments()
        
        // Check if a user with the given phone number exists
        guard let document = snapshot.documents.first else {
            print("User with phone number \(phoneNumber) not found")
            return
        }
        
        // Get the current balance
        let data = document.data()
        let currentBalance = data["kibetiBalance"] as? Double ?? 0.0
        
        // Calculate the new balance
        let newBalance = currentBalance + addAmount
        
        // Update the user's balance in Firestore
        try await usersCollection.document(document.documentID).updateData(["kibetiBalance": newBalance])
        
        print("Updated balance for user with phone number \(phoneNumber) to \(newBalance)")
    }
    
    
    func approveRequest(receiverPhoneNumber: String, sendersPhoneNumber: String) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating request approval.")
            return
        }
        // Use TransactionManager for atomic balance updates
        try await TransactionManager.instance.transferMoney(
            senderPhone: sendersPhoneNumber,
            receiverPhone: receiverPhoneNumber,
            amount: 500 // Hardcoded for this prototype/clone flow
        )
        
        // MARK: Update the request state to false
        let db = Firestore.firestore()
        let senderQuery = db.collection("users").whereField("phoneNumber", isEqualTo: sendersPhoneNumber)
        let senderSnapshot = try await senderQuery.getDocuments()
        guard let senderDocument = senderSnapshot.documents.first else { return }
        
        try await db.collection("requestState").document(senderDocument.documentID).updateData(["requestStatus": false])
    }

    func startListeningForRequestApproval(phoneNumber: String) {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Skipping snapshot listener.")
            return
        }
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Create a query to find the user with the given phone number
        let query = usersCollection.whereField("phoneNumber", isEqualTo: phoneNumber)
        
        query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error listening for balance updates: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                if change.type == .modified {
                    let data = change.document.data()
                    if let balance = data["kibetiBalance"] as? Double {
                        print("Balance updated to: \(balance)")
                        // Trigger UI update or show notification
                    }
                }
            }
        }
    }
    
    func initiateRequest(phoneNumber: String) async throws {
        try await updateRequestStateToTrue(phoneNumber: phoneNumber)
    }
    
    func updateRequestStateToTrue(phoneNumber: String) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Skipping updateRequestState.")
            return
        }
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Create a query to find the user with the given phone number
        let query = usersCollection.whereField("phoneNumber", isEqualTo: phoneNumber)
        
        // Execute the query
        let snapshot = try await query.getDocuments()
        
        // Check if a user with the given phone number exists
        guard let document = snapshot.documents.first else {
            print("User with phone number \(phoneNumber) not found")
            return
        }
        
        try await db.collection("requestState").document(document.documentID).updateData(["requestStatus": true])
    }
    
    
    func fetchAllDataOnLaunch() async -> (UserModel?, [Transaction]?) {
        guard isFirebaseConfigured else {
            return (UserModel(firstName: "Dominic", lastName: "Aisak", phoneNumber: "12345678", kibetiBalance: 345000.0), [])
        }
        do {
            let user = try await fetchUserDetails()
            let transactions = try await fetchTransactionHistory()
            return (user, transactions)
        } catch {
            print("Error on call on launch \(error.localizedDescription)")
            return (nil, nil)
        }
    }
}
