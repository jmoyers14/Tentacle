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