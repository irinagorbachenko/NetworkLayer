//
//  NetworkLayerTests.swift
//  NetworkLayerTests
//
//  Created by Irina Gorbachenko on 02.12.2021.
//

import XCTest
@testable import NetworkLayer


protocol NetworkSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask
}

protocol NetworkTask {
    func resume()
}

struct URLHTTPClient: HTTPClient {
    let session: NetworkSession
    private struct UnexpectedArguments: Error {}
    
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> ()) {
        let task: NetworkTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else  if let error = error {
                completion(.failure(error))
            } else{
                completion(.failure(UnexpectedArguments()))
            }
        }
        task.resume()
    }
}


class NetworkTaskSpy: NetworkTask {
    var data :Data?
    var response :URLResponse?
    var error : Error?
    
    var isCalled = false
    var completion: ((Data?, URLResponse?, Error?) -> Void)?

    func resume() {
        completion?(data, response, error)
        isCalled = true
    }
}

class NetworkSessionSpy: NetworkSession {

    var taskSpy: NetworkTaskSpy = NetworkTaskSpy()

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        taskSpy.completion = completionHandler
        return taskSpy
    }
}

enum SomeError: Error { case some}

class NetworkLayerTests: XCTestCase {
   
    func test_get_returnsErrorOnDataNilResponseNilErrorValid() {
        let exp = expectation(description: "waiting for response")
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = nil
        networkTask.response = nil
        networkTask.error = SomeError.some
        let sut = URLHTTPClient(session: session)

        let url = URL(string: "http://google.com")!
        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(SomeError.some, error as? SomeError)
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()
            }
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
        
    
    func test_get_returnsResponseDataErrorNilDataValid() {
        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = data
        networkTask.response = response
        networkTask.error = nil
        let sut = URLHTTPClient(session: session)


        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                XCTFail()
            case let .success((data, response)):
                break
            }
            exp.fulfill()
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    
}

