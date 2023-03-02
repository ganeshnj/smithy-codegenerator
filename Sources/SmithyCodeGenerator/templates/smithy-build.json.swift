import Foundation

struct SmithyBuildJson: Codable {
    let version: String
    let plugins: [String: Plugin]
}

struct Plugin: Codable {
    let service: String
    let module: String
    let moduleVersion: String
    let build: Build
    let gitRepo: String
    let author: String
    let homepage: String
    let swiftVersion: String
}

struct Build: Codable {
    let rootProject: Bool
}


extension SmithyBuildJson {
    /// {
    ///   "version": "1.0",
    ///   "plugins": {
    ///     "swift-codegen": {
    ///       "service": "example.weather#Weather",
    ///       "module": "weather",
    ///       "moduleVersion": "0.0.1",
    ///       "build": {
    ///         "rootProject": true
    ///       },
    ///       "gitRepo": "https://github.com/aws-amplify/smithy-swift.git",
    ///       "author": "Amazon Web Services",
    ///       "homepage": "https://docs.amplify.aws/",
    ///       "swiftVersion": "5.5.0"
    ///     }
    ///   }
    /// }
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}

