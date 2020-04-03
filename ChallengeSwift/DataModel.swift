import Foundation

// ResponseContent is a struct's representation Json
struct ResponseContent: Codable {
    let response: Response?
}

struct Response: Codable {
    let docs : [Articles]?
}

struct Articles: Codable {
    let abstract: String?
    let web_url: String?
    let snippet: String?
}

// ApiKey represents the archive that has a the access key
struct ApiKey: Codable {
    let key: String
}
