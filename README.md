# HttpRequest

A tiny http client for iOS and macOS. Only [80 lines](Sources/HttpRequest/HttpRequest.swift) of code.

### Get method

```swift
let request = HttpRequest(
    url: "https://httpbin.org/get",
    parameters: ["name": "Alex"],
)
request.json(HttpBin.self) { json, response in
    print(json)
}
```

### Post method

```swift
let request = HttpRequest(
    url: "https://httpbin.org/post",
    method: .post,
    parameters: ["name": "Alex"],
    headers: ["User-Agent": "HttpRequest"]
)
request.json(HttpBin.self) { json, response in
    if response.success {
         print(json)
    } else {
        print(response.error)
    }
}
```

### Access to URLRequest and HTTPURLResponse

```swift
var request = HttpRequest(
    url: "https://httpbin.org/get",
)
request.timeoutInterval = 30
request.cachePolicy = .reloadIgnoringCacheData
request.json(HttpBin.self) { json, response in
    print(response.original.statusCode)
    print(response.original.allHeaderFields)
}
```

### Get Json

```swift
struct HttpBin: Codable {
    let args: [String: String]?
    let form: [String: String]?
    let headers: [String: String]?
}

HttpRequest(
    url: "https://httpbin.org/get"
).json(HttpBin.self) { print($0) }
```

### Get Data and String

```swift
HttpRequest(
    url: "https://httpbin.org/get"
).data() { data, response in
    if let data = data {
        let string = String(
            data: data,
            encoding: .utf8
        )
        print(string)
    }
}

```

### Swift Package Manager

```
https://github.com/mezhevikin/http-request.git
```
