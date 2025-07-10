import Foundation

func sleep(seconds: Int) async throws {
    let nanoseconds: UInt64 = UInt64(seconds) * 1_000_000_000
    try await Task.sleep(nanoseconds: nanoseconds)
}
