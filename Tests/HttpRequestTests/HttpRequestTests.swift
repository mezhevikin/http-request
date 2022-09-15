import XCTest
@testable import HttpRequest

final class HttpRequestTests: XCTestCase {
    
    private struct HttpBin: Codable {
        let args: [String: String]?
        let form: [String: String]?
        let headers: [String: String]?
    }
    
    private let parameters = [
        "fisrtName": "Alexey",
        "lastName": "Mezhevikin"
    ]
    
    private let headers = [
        "User-Agent": "HttpRequest"
    ]
    
    func testGetRequest() throws {
        let request = HttpRequest(
            url: "https://httpbin.org/get",
            method: .get,
            parameters: parameters,
            headers: headers
        )
        let exp = XCTestExpectation(description: "request")
        request.json(HttpBin.self) { json, response in
            XCTAssertEqual(json?.args?["firstName"], self.parameters["firstName"])
            XCTAssertEqual(json?.args?["lastName"], self.parameters["lastName"])
            XCTAssertEqual(json?.headers?["User-Agent"], self.headers["User-Agent"])
            exp.fulfill()
        }
        wait(for: [exp], timeout: 30)
    }
    
    func testPostRequest() throws {
        let request = HttpRequest(
            url: "https://httpbin.org/post",
            method: .post,
            parameters: parameters,
            headers: headers
        )
        let exp = XCTestExpectation(description: "request")
        request.json(HttpBin.self) { json, response in
            XCTAssertEqual(json?.form?["firstName"], self.parameters["firstName"])
            XCTAssertEqual(json?.form?["lastName"], self.parameters["lastName"])
            XCTAssertEqual(json?.headers?["User-Agent"], self.headers["User-Agent"])
            XCTAssertTrue(response.success)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 30)
    }
    
    func testNotFound() throws {
        let exp = XCTestExpectation(description: "request")
        let request = HttpRequest(url: "https://httpbin.org/status/404")
        request.data() { response in
            XCTAssertFalse(response.success)
            XCTAssertEqual(response.original?.statusCode, 404)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 30)
    }
    
    func testUrlEncode() throws {
        XCTAssertEqual("&How are you?".urlEncoded, "%26How%20are%20you%3F")
    }
    
}
