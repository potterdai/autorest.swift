// --------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// --------------------------------------------------------------------------

import AzureCore
import Foundation
// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable cyclomatic_complexity

public struct PetAPInProperties: Codable {
    // MARK: Properties

    public let id: Int32

    public let name: String?

    public let status: Bool?
    /// Dictionary of <number>
    public let additionalProperties: [String: Float]?

    // MARK: Initializers

    /// Initialize a `PetAPInProperties` structure.
    /// - Parameters:
    ///   - id:
    ///   - name:
    ///   - status:
    ///   - additionalProperties: Dictionary of <number>
    public init(
        id: Int32, name: String? = nil, status: Bool? = nil, additionalProperties: [String: Float]? = nil
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.additionalProperties = additionalProperties
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case additionalProperties
    }

    /// Initialize a `PetAPInProperties` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.name = try? container.decode(String.self, forKey: .name)
        self.status = try? container.decode(Bool.self, forKey: .status)
        self.additionalProperties = try? container.decode([String: Float].self, forKey: .additionalProperties)
    }

    /// Encode a `PetAPInProperties` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        if name != nil { try? container.encode(name, forKey: .name) }
        if status != nil { try? container.encode(status, forKey: .status) }
        if additionalProperties != nil { try? container.encode(additionalProperties, forKey: .additionalProperties) }
    }
}