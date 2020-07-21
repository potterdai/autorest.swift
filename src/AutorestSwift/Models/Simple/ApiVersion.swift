//
//  ApiVersion.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public enum ApiVersionRange: String, Codable {
    case plus = "+"
    case minus = "-"
}

/// Since API version formats range from Azure ARM API date style (2018-01-01) to semver (1.2.3) and virtually any other text, this value tends to be an opaque string with the possibility of a modifier to indicate that it is a range.
/// options:
/// - prepend a dash or append a plus to indicate a range (ie, '2018-01-01+' or '-2019-01-01', or '1.0+' )
/// - semver-range style (ie, '^1.0.0' or '~1.0.0' )
public class ApiVersion: Codable {
    /// The actual API version string used in the API
    public let version: String

    public let range: ApiVersionRange?

    enum CodingKeys: String, CodingKey {
        case version, range
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        range = try? container.decode(ApiVersionRange?.self, forKey: .range)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        if range != nil { try? container.encode(range, forKey: .range) }
    }
}