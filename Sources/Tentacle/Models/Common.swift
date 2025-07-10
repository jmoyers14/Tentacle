import Foundation

// MARK: - OAuth Models
public struct AccessTokenResponse: Codable {
    var accessToken: String
    var tokenType: String
    var scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
    }
}

enum AccessTokenError: String, CaseIterable, Codable {
    case authorizationPending = "authorization_pending"
    case slowDown = "slow_down"
    case expiredToken = "expired_token"
    case unsupportedGrantType = "unsupported_grant_type"
    case incorrectClientCredentials = "incorrect_client_credentials"
    case incorrectDeviceCode = "incorrect_device_code"
    case accessDenied = "access_denied"
    case deviceFlowDisabled = "device_flow_disabled"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = AccessTokenError(rawValue: rawValue) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if self == .unknown {
            try container.encode("unknown_error")
        } else {
            try container.encode(rawValue)
        }
    }
}

struct AccessTokenErrorResponse: Codable, Error {
    let error: AccessTokenError
    let errorDescription: String
    let errorUri: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
        case errorUri = "error_uri"
    }
}

public struct DeviceCodeResponse: Codable {
    var deviceCode: String
    var userCode: String
    var verificationUri: String
    var expiresIn: Int
    var interval: Int

    enum CodingKeys: String, CodingKey {
        case deviceCode = "device_code"
        case userCode = "user_code"
        case verificationUri = "verification_uri"
        case expiresIn = "expires_in"
        case interval
    }
}

// MARK: - Helper for Dynamic Properties
public struct AnyCodable: Codable {
    public let value: Any

    public init<T>(_ value: T?) {
        self.value = value ?? ()
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(())
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([AnyCodable].self) {
            self.init(array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "AnyCodable value cannot be encoded")
            throw EncodingError.invalidValue(value, context)
        }
    }
}