import Foundation

// MARK: - User Models
public struct SimpleUser: Codable, Sendable {
    public let id: Int64
    public let nodeId: String
    public let login: String
    public let avatarUrl: String
    public let gravatarId: String?
    public let url: String
    public let htmlUrl: String
    public let followersUrl: String
    public let followingUrl: String
    public let gistsUrl: String
    public let starredUrl: String
    public let subscriptionsUrl: String
    public let organizationsUrl: String
    public let reposUrl: String
    public let eventsUrl: String
    public let receivedEventsUrl: String
    public let type: String
    public let siteAdmin: Bool
    public let name: String?
    public let email: String?
    public let starredAt: String?
    public let userViewType: String?

    enum CodingKeys: String, CodingKey {
        case id, login, url, type, name, email
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case siteAdmin = "site_admin"
        case starredAt = "starred_at"
        case userViewType = "user_view_type"
    }
}