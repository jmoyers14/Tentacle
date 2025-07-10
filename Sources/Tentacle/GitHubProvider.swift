import Foundation
@preconcurrency import Moya
import Moya

enum GitHubEndpoints {
    case getNotifications(query: NotificationQueryParameters, ifModifiedSince: String? = nil)
    case getDeviceVerificationCode(clientId: String, scope: String)
    case getAccessToken(clientId: String, deviceCode: String, grantType: String)
}

extension MoyaProvider {
    func request(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
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

struct JSONLoggingPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        print(
            "🚀 REQUEST: \(request.request?.httpMethod ?? "Unknown") \(request.request?.url?.absoluteString ?? "Unknown URL")"
        )

        if let headers = request.request?.allHTTPHeaderFields {
            print("📋 Headers: \(headers)")
        }

        if let body = request.request?.httpBody,
            let bodyString = String(data: body, encoding: .utf8)
        {
            print("📦 Body: \(bodyString)")
        }
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            print("✅ RESPONSE: \(response.statusCode) for \(target)")

            if let jsonObject = try? JSONSerialization.jsonObject(with: response.data, options: []),
                let prettyData = try? JSONSerialization.data(
                    withJSONObject: jsonObject, options: .prettyPrinted),
                let prettyString = String(data: prettyData, encoding: .utf8)
            {
                print("📄 JSON Response:")
                print(prettyString)
            } else {
                let rawString =
                    String(data: response.data, encoding: .utf8) ?? "Unable to decode response data"
                print("📄 Raw Response: \(rawString)")
            }

        case .failure(let error):
            print("❌ ERROR: \(error) for \(target)")

            if let response = error.response {
                print("📄 Error Response Data:")
                let errorString =
                    String(data: response.data, encoding: .utf8) ?? "Unable to decode error data"
                print(errorString)
            }
        }
    }
}
