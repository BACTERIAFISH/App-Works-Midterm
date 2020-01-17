//
//  UserProvider.swift
//  App Works Midterm
//
//  Created by FISH on 2020/1/17.
//  Copyright © 2020 FISH. All rights reserved.
//

import Foundation
import Alamofire

class UserProvider {
    
    private let decoder = JSONDecoder()

    func getToken() {

        let urlString = "https://account.kkbox.com/oauth2/token"

        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = "grant_type=client_credentials&client_id=1d5e157d2ed75f2a514c3fa15219c2ed&client_secret=29ce4b8e701130fd11be2ef75919f4c2".data(using: .utf8)
        
        request.httpBody = body
        
        HTTPClient.shared.fetch(request: request) { [weak self] (result) in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let data):

                do {
                    let response = try strongSelf.decoder.decode(ClientResponse.self, from: data)
                    print(response)
                    //UserDefaults.standard.set(response.accessToken, forKey: "KKBOXAccessToken")

                } catch {
                    print("get token decode error: \(error)")
                }

            case .failure(let error):
                print("http error: \(error)")

            }
        }
    }
}

struct ClientResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
