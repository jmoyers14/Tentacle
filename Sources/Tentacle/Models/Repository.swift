import Foundation

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

// MARK: - Supporting Repository Models
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