import Foundation
import Tentacle

Task {
    do {
        loadDotEnv()

        guard let clientId = ProcessInfo.processInfo.environment["GITHUB_CLIENT_ID"] else {
            print("GITHUB_CLIENT_ID env variable not set")
            return
        }

        guard let gitHubPAT = ProcessInfo.processInfo.environment["GITHUB_PAT"] else {
            print("GITHUB_PAT env variable not set")
            return
        }

        let gitHub = GitHubClient(clientId: clientId)
        gitHub.setPAT(token: gitHubPAT)

        let notifications = try await gitHub.notifications.list()

        print(notifications[0])

    } catch {
        print("Error \(error)")
    }
}

print("Waiting for response...")
RunLoop.main.run()
