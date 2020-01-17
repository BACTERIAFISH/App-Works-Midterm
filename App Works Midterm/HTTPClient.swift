//
//  HTTPClient.swift
//  App Works Midterm
//
//  Created by FISH on 2020/1/17.
//  Copyright © 2020 FISH. All rights reserved.
//

import Foundation

enum HTTPClientError: Error {
    
    case noDataOrResponse

    case decodeDataFail

    case clientError(Data)

    case serverError

    case unexpectedError
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private init() {}
    
    func fetch(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(Result.failure(error))
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                return completion(Result.failure(HTTPClientError.noDataOrResponse))
            }
            
            switch response.statusCode {
            case 200..<300:
                completion(Result.success(data))
            case 400..<500:
                completion(Result.failure(HTTPClientError.clientError(data)))
            case 500..<600:
                completion(Result.failure(HTTPClientError.serverError))
            default:
                completion(Result.failure(HTTPClientError.unexpectedError))
            }
        }
        
        task.resume()
    }
}

