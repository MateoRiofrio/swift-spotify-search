//
//  AuthManager.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import Foundation
import CryptoKit

final class AuthManager {
    
    //SPOTIFY AUTH CONSTANTS
    private struct AuthConstants {
        static let authURI = "https://accounts.spotify.com/authorize"
        static let returnURI = "http%3A%2F%2F127.0.0.1%3A5500%2Findex.html" // used a live server url (vscode)
        static let tokenEndpoint = "https://accounts.spotify.com/api/token"
    }
    
    private let client = HTTPClient(session: URLSession.shared)
    
    static var shared = AuthManager()
    
    public var isSignedIn: Bool { return self.accessToken != nil }
    
    private var codeVerifier: String = ""
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration_date") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
        
    }
    
    private func generateCodeVerifier(n: Int) -> String {
        // return a random string using 'unreserved' characters of size n
        let unreserved = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-._~"
        return String((0..<n).map{_ in unreserved.randomElement()!})
    }
    
    private func generateCodeChallenge(verifier: String) -> String {
        // convert verifier string to Data type to hash using sha256
        let verifierData = Data(verifier.utf8)
        // hold the sha256 hash in a data object to encode to base64
        let hashedVerifier = Data(SHA256.hash(data:verifierData))
        
        // enconde to base 64 as a String to later encode to base64url
        let base64Encoded = hashedVerifier.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        // encode to base64url as API requires url version
        var base64UrlEncoded = base64Encoded.replacingOccurrences(of: "+", with: "-")
        base64UrlEncoded = base64UrlEncoded.replacingOccurrences(of: "/", with: "_")
        base64UrlEncoded = base64UrlEncoded.trimmingCharacters(in: ["="])
        return base64UrlEncoded
    }
    
    private func getCodeVerifier() -> String {
        codeVerifier = generateCodeVerifier(n: Int.random(in: 43..<129))
        return codeVerifier
    }
    
    private func getCodeChallenge(verifier: String) -> String {
        return generateCodeChallenge(verifier: verifier)
    }
    
    func getAuthorizationUri() -> URL? {
        let scopes = ""
        if let clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String {
            return URL(string: AuthConstants.authURI + "?response_type=code" +
                        "&client_id=" + clientId +
                        //"&scope=" + scopes +
                        "&redirect_uri=" + AuthConstants.returnURI +
                        "&code_challenge=" + getCodeChallenge(verifier: getCodeVerifier()) +
                        "&code_challenge_method=S256")
        }
        else { return nil }
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        // // make sure these values are not null as they are needed for the request
        guard codeVerifier != "", let clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String
        else {
            completion(false)
            return
        }
        
        // construct required paramaters
        let params: [String: String] = [
            "client_id": clientId,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": AuthConstants.returnURI,
            "code_verifier": codeVerifier
        ]
        
        // construct request and handle response
        client.post(
            url: AuthConstants.tokenEndpoint,
            params: params,
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        ) { data, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        
    }
    
    public func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
        // if the previous token has not expired, then there is no need to refresh it yet
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        // make sure these values are not null as they are needed for the request
        guard let refreshToken = self.refreshToken,
              let clientId = Bundle.main.infoDictionary?["CLIENT_ID"] as? String
        else {
            completion(false)
            return
        }
        
        let params: [String: String] = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
            "client_id": clientId
        ]
        
        client.post(
            url: AuthConstants.tokenEndpoint,
            params: params,
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        ) { data, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
            
        }
    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration_date")
    }
}
