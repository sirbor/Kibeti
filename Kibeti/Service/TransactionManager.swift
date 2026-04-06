//
//  TransactionManager.swift
//  Kibeti
//

import Foundation
import Firebase
import FirebaseFirestore

class TransactionManager {
    static let instance = TransactionManager()
    
    private let db = Firestore.firestore()
    private let databaseService = DatabaseService.instance
    
    /// Handles the entire transfer process between two users
    func transferMoney(senderPhone: String, receiverPhone: String, amount: Double) async throws {
        // 1. Validate sender balance (this should ideally be done in VM before calling this)
        let senderDoc = try await findUserDocument(phoneNumber: senderPhone)
        let senderBalance = senderDoc.data()["kibetiBalance"] as? Double ?? 0.0
        
        guard senderBalance >= amount else {
            throw NSError(domain: "TransactionManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insufficient balance"])
        }
        
        // 2. Find receiver
        let receiverDoc = try await findUserDocument(phoneNumber: receiverPhone)
        let receiverBalance = receiverDoc.data()["kibetiBalance"] as? Double ?? 0.0
        
        // 3. Perform atomic transaction
        _ = try await db.runTransaction { (transaction, errorPointer) -> Any? in
            // Update sender balance
            transaction.updateData(["kibetiBalance": senderBalance - amount], forDocument: senderDoc.reference)
            
            // Update receiver balance
            transaction.updateData(["kibetiBalance": receiverBalance + amount], forDocument: receiverDoc.reference)
            
            return nil
        }
        
        // 4. Record history for sender
        let senderTransaction = Transaction(
            contact: Contact(givenName: "To:", familyName: receiverPhone, mobileNumber: receiverPhone),
            phoneNumber: receiverPhone,
            date: Date(),
            amount: amount
        )
        try await databaseService.saveTransactionHistory(transaction: senderTransaction)
        
        // 5. Record history for receiver (Optional: depending on requirements)
        // In a real app, you'd record this in the receiver's history as an incoming transaction
    }
    
    private func findUserDocument(phoneNumber: String) async throws -> QueryDocumentSnapshot {
        let snapshot = try await db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments()
        guard let document = snapshot.documents.first else {
            throw NSError(domain: "TransactionManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User with phone \(phoneNumber) not found"])
        }
        return document
    }
}
