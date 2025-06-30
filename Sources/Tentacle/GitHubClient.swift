import Foundation
@preconcurrency import Moya

public class GitHubClient {
    public private(set) var notifications: Notifications
    public private(set) var oauth: OAuth
    private let tokenStore = TokenStore()

    public init(clientId: String) {
        let authPlugin = AccessTokenPlugin { [weak tokenStore] _ in
            return tokenStore?.accessToken ?? ""
        }
        let jsonLogginPlugin = JSONLoggingPlugin()

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let provider = MoyaProvider<GitHubEndpoints>(plugins: [authPlugin, jsonLogginPlugin])
        self.oauth = OAuth(clientId: clientId, provider: provider)
        self.notifications = Notifications(
            provider: provider, tokenStore: tokenStore, jsonDecoder: decoder)
    }

    public func setPAT(token: String) {
        self.tokenStore.setToken(token)
    }
}
