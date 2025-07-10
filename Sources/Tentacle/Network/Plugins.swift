import Foundation
@preconcurrency import Moya

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