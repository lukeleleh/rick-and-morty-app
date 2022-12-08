import Foundation

/// Represents an HTTP task.
public enum Task {
    /// A request with no additional data.
    case requestPlain

    /// A requests body set with encoded parameters.
    case request(parameters: Encodable)
}
