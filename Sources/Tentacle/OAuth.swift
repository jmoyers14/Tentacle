@preconcurrency import Moya

public class OAuth {
    private let provider: MoyaProvider<GitHubEndpoints>
    private let clientId: String

    init(clientId: String, provider: MoyaProvider<GitHubEndpoints>) {
        self.provider = provider
        self.clientId = clientId
    }

    public func accessToken(deviceCode: String) async throws -> AccessTokenResponse {
        let response = try await provider.request(
            .getAccessToken(
                clientId: self.clientId, deviceCode: deviceCode,
                grantType: "urn:ietf:params:oauth:grant-type:device_code"))

        let result = try response.map(
            OneOf<AccessTokenErrorResponse, AccessTokenResponse>.self)
        switch result {
        case .left(let error):
            throw error
        case .right(let tokenResponse):
            return tokenResponse
        }
    }

    public func deviceCode() async throws -> DeviceCodeResponse {
        let response = try await provider.request(
            .getDeviceVerificationCode(
                clientId: self.clientId, scope: "notifications repo"))
        return try response.map(DeviceCodeResponse.self)
    }

    public func pollAccessToken(deviceCode: String, interval: Int) async throws -> String {
        let maxAttempts = 100
        var attempts = 0

        while attempts < maxAttempts {
            do {
                let response = try await self.accessToken(deviceCode: deviceCode)
                return response.accessToken
            } catch let error as AccessTokenErrorResponse {
                attempts += 1
                switch error.error {
                case .authorizationPending:
                    print("authorization pending")
                    try await sleep(seconds: interval)
                case .slowDown:
                    print("slow down")
                    try await sleep(seconds: interval * 2)
                default:
                    print("non retryable error \(error.errorDescription)")
                    throw error
                }
            }
        }

        return "not a token"
    }
}

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
