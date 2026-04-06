//
//  FirebaseAuth.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//
import Foundation
import Firebase
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore
import FirebaseStorage

struct AuthDataResult {
    let uid: String
    let phoneNumber: String
    
    init(user: User) {
        self.uid = user.uid
        self.phoneNumber = user.phoneNumber ?? ""
    }
}

class FirebaseAuth {
    static let instance = FirebaseAuth()
    
    private var isFirebaseConfigured: Bool {
        FirebaseApp.allApps?.keys.contains("__FIRAPP_DEFAULT") ?? false
    }
    
    // send verification code
    func sendVerificationCode(for phoneNumber: String) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating code sent for: \(phoneNumber)")
            UserDefaults.standard.set("mock_verification_id", forKey: "authVerificationID")
            return
        }
        
        let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
    }
    
    // verify the code and create user account
    
    func verifyUserCode(verificationCode: String, completion: @escaping (Bool, AuthDataResult?) -> Void) async throws {
        guard isFirebaseConfigured else {
            print("DEBUG: Firebase not configured. Simulating successful verification.")
            // Return a dummy result for the UI to proceed
            completion(true, nil)
            return
        }
        
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { throw URLError(.badURL) }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        do {
            let authDataResult = try await Auth.auth().signIn(with: credential)
            completion(true, AuthDataResult(user: authDataResult.user))
        } catch {
            print("error verifying user \(error.localizedDescription)")
            completion(false, nil)
        }
            
    }
    
    // returns the authenticated user
    func fetchAuthUser() throws -> AuthDataResult {
        guard isFirebaseConfigured, let currentUser = Auth.auth().currentUser else {
            // Return mock data if not configured
            throw URLError(.cancelled)
        }
        return AuthDataResult(user: currentUser)
    }

    func logout() async {
        guard isFirebaseConfigured else { return }
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error logging out")
        }
    }
}

