enum OneOf<Left, Right> {
    case left(Left)
    case right(Right)
}

extension OneOf: Decodable where Left: Decodable, Right: Decodable {
    init(from decoder: Decoder) throws {
        if let leftValue = try? Left(from: decoder) {
            self = .left(leftValue)
            return
        }

        if let rightValue = try? Right(from: decoder) {
            self = .right(rightValue)
            return
        }

        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Could not decode as either \(Left.self) or \(Right.self)"
            )
        )
    }
}
