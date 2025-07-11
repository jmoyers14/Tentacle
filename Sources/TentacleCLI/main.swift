import Foundation
import Tentacle

func onNotifications(notifications: [GitHubNotification], nextRequstIn: Int) {
    print("Got Notifications! next request in: \(nextRequstIn)")
}

func onError(error: Error) {
    print("Got Error")
}

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

        let query = NotificationQueryParameters(all: true)

        await gitHub.notifications.poll(
            query: query,
            onNotifications: onNotifications, onError: onError)

    } catch {
        print("Error \(error)")
    }
}

print("Waiting for response...")
RunLoop.main.run()
