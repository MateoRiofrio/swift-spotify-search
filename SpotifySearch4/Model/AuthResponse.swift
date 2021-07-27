//
//  AuthResponse.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import Foundation

struct AuthResponse: Codable {
    let access_token:String
    let token_type: String
    let scope: String?
    let expires_in: Int
    let refresh_token: String
}
