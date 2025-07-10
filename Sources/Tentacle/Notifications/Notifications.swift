import Foundation
@preconcurrency import Moya

public class Notifications {
    private let provider: MoyaProvider<GitHubEndpoints>
    private let tokenStore: TokenStore
    private let jsonDecoder: JSONDecoder

    init(provider: MoyaProvider<GitHubEndpoints>, tokenStore: TokenStore, jsonDecoder: JSONDecoder)
    {
        self.jsonDecoder = jsonDecoder
        self.provider = provider
        self.tokenStore = tokenStore
    }

    public func list() async throws -> [GitHubNotification] {
        let query = NotificationQueryParameters()
        let response = try await self.provider.request(
            .getNotifications(query: query))
        return try response.map(NotificationsResponse.self, using: self.jsonDecoder)
    }

    public func poll(
        query: NotificationQueryParameters,
        onNotifications: @escaping ([GitHubNotification], Int) -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        var polling = true
        var ifModifiedSince: String?

        while polling {
            do {
                let response = try await self.provider.request(
                    .getNotifications(query: query, ifModifiedSince: ifModifiedSince))

                guard let httpResponse = response.response,
                    let xPollInterval = httpResponse.headers["X-Poll-Interval"],
                    let lastModified = httpResponse.headers["Last-Modified"],
                    let pollIntervalSeconds = Int(xPollInterval)
                else {
                    polling = false
                    break
                }

                let notifications = try response.map(
                    NotificationsResponse.self, using: self.jsonDecoder)
                onNotifications(notifications, pollIntervalSeconds)
                ifModifiedSince = lastModified

                try await sleep(seconds: pollIntervalSeconds)
            } catch {
                polling = false
                onError(error)
            }
        }
    }
}