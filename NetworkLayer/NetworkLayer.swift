//
//  NetworkLayer.swift
//  NetworkLayer
//
//  Created by Irina Gorbachenko on 02.12.2021.
//

import Foundation

import UIKit

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ())
}
public protocol NetworkSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}

public protocol NetworkTask {
    func resume()
}

public class URLHTTPClient: HTTPClient {
    let session: NetworkSession
    private struct UnexpectedArguments: Error {}
    
    public init(session: NetworkSession) {
        self.session = session
    }

    public func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
        let task: NetworkTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else  if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else{
                completion(.failure(UnexpectedArguments()))
            }

        }
        task.resume()
    }
}



public struct ImageLoader {
    
    public let session: HTTPClient
    
    public init(with session: HTTPClient) {
        self.session = session
    }
    
    public  func load(from url: URL, completion: @escaping (UIImage) -> ()) {
        session.get(from: url) { (result) in
            switch result {
            case let .success(data, _):
                completion(UIImage(data: data)!)
            case let .failure(error):
                break
            }
            
        }
    }
}


