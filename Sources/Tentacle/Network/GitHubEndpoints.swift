import Foundation
@preconcurrency import Moya
import Moya

enum GitHubEndpoints {
    case getNotifications(query: NotificationQueryParameters, ifModifiedSince: String? = nil)
    case getDeviceVerificationCode(clientId: String, scope: String)
    case getAccessToken(clientId: String, deviceCode: String, grantType: String)
}

extension GitHubEndpoints: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .getAccessToken, .getDeviceVerificationCode:
            return nil
        case .getNotifications:
            return .bearer
        }
    }
}

extension GitHubEndpoints: TargetType {
    var baseURL: URL {
        switch self {
        case .getAccessToken, .getDeviceVerificationCode:
            return URL(string: "https://github.com")!
        case .getNotifications:
            return URL(string: "https://api.github.com")!
        }
    }

    var path: String {
        switch self {
        case .getAccessToken:
            return "/login/oauth/access_token"
        case .getDeviceVerificationCode:
            return "/login/device/code"
        case .getNotifications:
            return "/notifications"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getDeviceVerificationCode, .getAccessToken:
            return .post
        case .getNotifications:
            return .get
        }
    }

    var task: Moya.Task {
        switch self {
        case let .getDeviceVerificationCode(clientId, scope):
            return .requestParameters(
                parameters: ["client_id": clientId, "scope": scope],
                encoding: URLEncoding.queryString)
        case let .getAccessToken(clientId, deviceCode, grantType):
            return .requestParameters(
                parameters: [
                    "client_id": clientId, "device_code": deviceCode, "grant_type": grantType,
                ], encoding: URLEncoding.queryString)
        case let .getNotifications(query, _):
            return .requestParameters(
                parameters: query.toDictionary(), encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        var headers =
            ["Content-type": "application/json", "Accept": "application/json"]
        switch self {
        case let .getNotifications(_, ifModifiedSince):
            if ifModifiedSince != nil {
                headers["If-Modified-Since"] = ifModifiedSince
            }
            return headers
        default:
            return headers
        }
    }
}