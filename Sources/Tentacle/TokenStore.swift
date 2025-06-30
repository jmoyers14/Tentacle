class TokenStore {
    private(set) var accessToken: String?

    func setToken(_ token: String) {
        accessToken = token
    }

    func clearToken() {
        accessToken = nil
    }

    var hasToken: Bool {
        return accessToken != nil
    }
}
