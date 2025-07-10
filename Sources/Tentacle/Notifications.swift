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

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]

        if all {
            dict["all"] = true
        }

        if participating {
            dict["participating"] = true
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

// MARK: - Repository Models
public struct MinimalRepository: Codable, Sendable {
    public let id: Int64
    public let nodeId: String
    public let name: String
    public let fullName: String
    public let owner: SimpleUser
    public let isPrivate: Bool
    public let htmlUrl: String
    public let description: String?
    public let fork: Bool
    public let url: String

    // URL properties
    public let archiveUrl: String
    public let assigneesUrl: String
    public let blobsUrl: String
    public let branchesUrl: String
    public let collaboratorsUrl: String
    public let commentsUrl: String
    public let commitsUrl: String
    public let compareUrl: String
    public let contentsUrl: String
    public let contributorsUrl: String
    public let deploymentsUrl: String
    public let downloadsUrl: String
    public let eventsUrl: String
    public let forksUrl: String
    public let gitCommitsUrl: String
    public let gitRefsUrl: String
    public let gitTagsUrl: String
    public let hooksUrl: String
    public let issueCommentUrl: String
    public let issueEventsUrl: String
    public let issuesUrl: String
    public let keysUrl: String
    public let labelsUrl: String
    public let languagesUrl: String
    public let mergesUrl: String
    public let milestonesUrl: String
    public let notificationsUrl: String
    public let pullsUrl: String
    public let releasesUrl: String
    public let stargazersUrl: String
    public let statusesUrl: String
    public let subscribersUrl: String
    public let subscriptionUrl: String
    public let tagsUrl: String
    public let teamsUrl: String
    public let treesUrl: String

    // Repository metadata
    public let gitUrl: String?
    public let sshUrl: String?
    public let cloneUrl: String?
    public let svnUrl: String?
    public let mirrorUrl: String?
    public let homepage: String?
    public let language: String?
    public let forksCount: Int?
    public let stargazersCount: Int?
    public let watchersCount: Int?
    public let size: Int?
    public let defaultBranch: String?
    public let openIssuesCount: Int?
    public let isTemplate: Bool?
    public let topics: [String]?
    public let hasIssues: Bool?
    public let hasProjects: Bool?
    public let hasWiki: Bool?
    public let hasPages: Bool?
    public let hasDownloads: Bool?
    public let hasDiscussions: Bool?
    public let archived: Bool?
    public let disabled: Bool?
    public let visibility: String?
    public let pushedAt: Date?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let permissions: RepositoryPermissions?
    public let roleName: String?
    public let tempCloneToken: String?
    public let deleteBranchOnMerge: Bool?
    public let subscribersCount: Int?
    public let networkCount: Int?
    public let codeOfConduct: CodeOfConduct?
    public let license: RepositoryLicense?
    public let forks: Int?
    public let openIssues: Int?
    public let watchers: Int?
    public let allowForking: Bool?
    public let webCommitSignoffRequired: Bool?
    public let securityAndAnalysis: SecurityAndAnalysis?
    //public let customProperties: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case id, name, fork, url, language, topics, archived, disabled, visibility, forks, watchers,
            license
        case nodeId = "node_id"
        case fullName = "full_name"
        case owner
        case isPrivate = "private"
        case htmlUrl = "html_url"
        case description
        case archiveUrl = "archive_url"
        case assigneesUrl = "assignees_url"
        case blobsUrl = "blobs_url"
        case branchesUrl = "branches_url"
        case collaboratorsUrl = "collaborators_url"
        case commentsUrl = "comments_url"
        case commitsUrl = "commits_url"
        case compareUrl = "compare_url"
        case contentsUrl = "contents_url"
        case contributorsUrl = "contributors_url"
        case deploymentsUrl = "deployments_url"
        case downloadsUrl = "downloads_url"
        case eventsUrl = "events_url"
        case forksUrl = "forks_url"
        case gitCommitsUrl = "git_commits_url"
        case gitRefsUrl = "git_refs_url"
        case gitTagsUrl = "git_tags_url"
        case gitUrl = "git_url"
        case hooksUrl = "hooks_url"
        case issueCommentUrl = "issue_comment_url"
        case issueEventsUrl = "issue_events_url"
        case issuesUrl = "issues_url"
        case keysUrl = "keys_url"
        case labelsUrl = "labels_url"
        case languagesUrl = "languages_url"
        case mergesUrl = "merges_url"
        case milestonesUrl = "milestones_url"
        case notificationsUrl = "notifications_url"
        case pullsUrl = "pulls_url"
        case releasesUrl = "releases_url"
        case sshUrl = "ssh_url"
        case stargazersUrl = "stargazers_url"
        case statusesUrl = "statuses_url"
        case subscribersUrl = "subscribers_url"
        case subscriptionUrl = "subscription_url"
        case tagsUrl = "tags_url"
        case teamsUrl = "teams_url"
        case treesUrl = "trees_url"
        case cloneUrl = "clone_url"
        case mirrorUrl = "mirror_url"
        case svnUrl = "svn_url"
        case homepage
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case size
        case defaultBranch = "default_branch"
        case openIssuesCount = "open_issues_count"
        case isTemplate = "is_template"
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case hasDownloads = "has_downloads"
        case hasDiscussions = "has_discussions"
        case pushedAt = "pushed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case permissions
        case roleName = "role_name"
        case tempCloneToken = "temp_clone_token"
        case deleteBranchOnMerge = "delete_branch_on_merge"
        case subscribersCount = "subscribers_count"
        case networkCount = "network_count"
        case codeOfConduct = "code_of_conduct"
        case openIssues = "open_issues"
        case allowForking = "allow_forking"
        case webCommitSignoffRequired = "web_commit_signoff_required"
        case securityAndAnalysis = "security_and_analysis"
        //case customProperties = "custom_properties"
    }
}

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

// MARK: - Supporting Models
public struct RepositoryPermissions: Codable, Sendable {
    public let admin: Bool?
    public let maintain: Bool?
    public let push: Bool?
    public let triage: Bool?
    public let pull: Bool?
}

public struct CodeOfConduct: Codable, Sendable {
    public let key: String
    public let name: String
    public let url: String
    public let body: String?
    public let htmlUrl: String?

    enum CodingKeys: String, CodingKey {
        case key, name, url, body
        case htmlUrl = "html_url"
    }
}

public struct RepositoryLicense: Codable, Sendable {
    public let key: String?
    public let name: String?
    public let spdxId: String?
    public let url: String?
    public let nodeId: String?

    enum CodingKeys: String, CodingKey {
        case key, name, url
        case spdxId = "spdx_id"
        case nodeId = "node_id"
    }
}

public struct SecurityAndAnalysis: Codable, Sendable {
    public let advancedSecurity: SecurityFeature?
    public let codeSecurity: SecurityFeature?
    public let dependabotSecurityUpdates: SecurityFeature?
    public let secretScanning: SecurityFeature?
    public let secretScanningPushProtection: SecurityFeature?
    public let secretScanningNonProviderPatterns: SecurityFeature?
    public let secretScanningAiDetection: SecurityFeature?

    enum CodingKeys: String, CodingKey {
        case advancedSecurity = "advanced_security"
        case codeSecurity = "code_security"
        case dependabotSecurityUpdates = "dependabot_security_updates"
        case secretScanning = "secret_scanning"
        case secretScanningPushProtection = "secret_scanning_push_protection"
        case secretScanningNonProviderPatterns = "secret_scanning_non_provider_patterns"
        case secretScanningAiDetection = "secret_scanning_ai_detection"
    }
}

public struct SecurityFeature: Codable, Sendable {
    public let status: String?
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
