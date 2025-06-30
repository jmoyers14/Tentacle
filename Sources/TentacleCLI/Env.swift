import Foundation

func loadDotEnv() {
    guard let envPath = findEnvFile() else { return }

    print(envPath)

    do {
        let content = try String(contentsOfFile: envPath)
        let lines = content.components(separatedBy: .newlines)

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard !trimmed.isEmpty && !trimmed.hasPrefix("#") else { continue }

            let parts = trimmed.components(separatedBy: "=")
            guard parts.count >= 2 else { continue }

            let key = parts[0].trimmingCharacters(in: .whitespaces)
            let value = parts[1...].joined(separator: "=").trimmingCharacters(in: .whitespaces)

            setenv(key, value, 1)
        }
    } catch {
        print("Could not load .env file: \(error)")
    }
}

func findEnvFile() -> String? {
    let currentDir = FileManager.default.currentDirectoryPath
    let envPath = "\(currentDir)/.env"
    print(envPath)
    return FileManager.default.fileExists(atPath: envPath) ? envPath : nil
}
