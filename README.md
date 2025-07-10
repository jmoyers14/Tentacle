# Tentacle

A Swift GitHub API client tailored for building GitHub notification inbox applications.

## Overview

**Tentacle** is a Swift package that provides an async/await-based interface for interacting with GitHub's notification API.

### Key Features

- **Async/await support** - Modern Swift concurrency
- **GitHub OAuth integration** - Device flow authentication
- **Notification polling** - Real-time notification updates

## Components

### Tentacle (Library)

The core Swift package containing:

- **GitHubClient** - Main entry point for API interactions
- **Notifications** - Fetch and poll GitHub notifications
- **OAuth** - Handle GitHub device flow authentication

### TentacleCLI (Test Application)

A command-line interface for testing the Tentacle package functionality.

## Usage

```swift
import Tentacle

// Initialize the GitHub client
let client = GitHubClient()

// Set your Personal Access Token
client.setPersonalAccessToken("your_github_token")

// Fetch notifications
let notifications = try await client.notifications.list()

// Poll for updates
await client.notifications.poll(
    query: NotificationQueryParameters(),
    onNotifications: { notifications, interval in
        print("Received \(notifications.count) notifications")
    },
    onError: { error in
        print("Error: \(error)")
    }
)
```

## Requirements

- Swift 6.0+
- macOS 10.15+ / iOS 13+
