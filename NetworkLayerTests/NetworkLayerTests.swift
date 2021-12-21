//
//  NetworkLayerTests.swift
//  NetworkLayerTests
//
//  Created by Irina Gorbachenko on 02.12.2021.
//

import XCTest
@testable import NetworkLayer
 
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
   
    //MARK:data: nil,response: nil,error: value, status: valid
    func test_get_withDataResponseNilErrorDataValid() {
        let exp = expectation(description: "waiting for response")
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = nil
        networkTask.response = nil
        networkTask.error = SomeError.some
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)
        
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
        
    //MARK:data: value,response: value,error: nil, status: valid
    func test_get_withResponseDataValueErrorNilValid() {
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
        memoryLeakTrack(sut)

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
    
    //MARK:data: nil,response: nil,error: nil, status: invalid
    func test_get_withAllNilArgumentsReturnsError() {
        
        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = nil
        networkTask.response = nil
        networkTask.error = nil
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)

        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()
            }
            
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    //MARK:data: nil,response: value,error: nil, status: invalid
    func test_get_withResponseValueDataErrorNilReturnsError() {
        
        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = nil
        networkTask.response = response
        networkTask.error = nil
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)

        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()
            }
            
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    
    //MARK:data: value,response: nil,error: nil, status: invalid
    func test_get_withDataValueResponseErrorNilReturnsError() {
        
        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = data
        networkTask.response = nil
        networkTask.error = nil
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)

        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()
            }
            
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    
    //MARK:data: value,response: nil,error: value, status: invalid
    func test_get_withDataValueResponseNilErrorValueReturnsError() {
        
        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = data
        networkTask.response = nil
        networkTask.error = SomeError.some
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)

        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()
            }
            
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    
    //MARK:data: nil,response: value,error: value, status: invalid
    func test_get_withDataNilResponseErrorValueReturnsError() {
        
        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = nil
        networkTask.response = response
        networkTask.error = SomeError.some
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)


        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()
            }
            
        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    
    //MARK:data: value,response: value,error: value, status: invalid
    func test_get_withaAllDataResponseErrorValueReturnsError() {   

        let exp = expectation(description: "waiting for response")
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = data
        networkTask.response = response
        networkTask.error = SomeError.some
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)
       
        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()

            }

        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
    }
    

    func memoryLeakTrack(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {

    addTeardownBlock { [weak instance] in

    XCTAssertNil(instance, "Potential leak.", file: file, line: line)

    }

    }
    
    func test_get_noSideEffect(){
        
        
        let exp = expectation(description: "waiting for response")
        exp.expectedFulfillmentCount = 2
        let url = URL(string: "http://google.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = Data()
        let networkTask = NetworkTaskSpy()
        let session = NetworkSessionSpy()
        session.taskSpy = networkTask
        networkTask.data = data
        networkTask.response = response
        networkTask.error = SomeError.some
        let sut = URLHTTPClient(session: session)
        memoryLeakTrack(sut)
       
        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()

            }

        }
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(error):
                exp.fulfill()
            case let .success((data, response)):
                XCTFail()

            }

        }

        XCTAssertTrue(networkTask.isCalled)
        wait(for: [exp], timeout: 0.1)
        
        
        
    }
}

