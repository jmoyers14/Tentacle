import Foundation

// MARK: - Main Response Types
public typealias NotificationsResponse = [GitHubNotification]

public struct GitHubNotification: Codable, Sendable {
    public let id: String
    public let repository: MinimalRepository
    public let subject: NotificationSubject
    public let reason: String
    public let unread: Bool
    public let updatedAt: Date
    public let lastReadAt: Date?
    public let url: String
    public let subscriptionUrl: String

    enum CodingKeys: String, CodingKey {
        case id, repository, subject, reason, unread, url
        case updatedAt = "updated_at"
        case lastReadAt = "last_read_at"
        case subscriptionUrl = "subscription_url"
    }
}

// MARK: - Notification Subject
public struct NotificationSubject: Codable, Sendable {
    public let title: String
    public let url: String
    public let latestCommentUrl: String?
    public let type: String

    enum CodingKeys: String, CodingKey {
        case title, url, type
        case latestCommentUrl = "latest_comment_url"
    }
}

public struct NotificationQueryParameters {
    var all: Bool = false
    var participating: Bool = false
    var since: Date?
    var before: Date?
    var page: Int = 1
    var perPage: Int = 50

    public init(
        all: Bool = false, participating: Bool = false, since: Date? = nil, before: Date? = nil,
        page: Int = 1, perPage: Int = 50
    ) {
        self.all = all
        self.participating = participating
        self.since = since
        self.before = before
        self.page = page
        self.perPage = perPage
    }

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]

        if all {
            dict["all"] = "true"
        }

        if participating {
            dict["participating"] = "true"
        }

        if let since = since {
            dict["since"] = ISO8601DateFormatter().string(from: since)
        }

        if let before = before {
            dict["before"] = ISO8601DateFormatter().string(from: before)
        }

        if page != 1 {
            dict["page"] = page
        }

        if perPage != 50 {
            dict["per_page"] = perPage
        }

        return dict
    }
}

