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

public struct PetActionError: Codable, Swift.Error {
    // MARK: Properties

    public let errorType: String
    /// the error message
    public let errorMessage: String?
    /// action feedback
    public let actionResponse: String?

    // MARK: Initializers

    /// Initialize a `PetActionError` structure.
    /// - Parameters:
    ///   - errorType:
    ///   - errorMessage: the error message
    ///   - actionResponse: action feedback
    public init(
        errorType: String, errorMessage: String? = nil, actionResponse: String? = nil
    ) {
        self.errorType = errorType
        self.errorMessage = errorMessage
        self.actionResponse = actionResponse
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case errorType
        case errorMessage
        case actionResponse
    }

    /// Initialize a `PetActionError` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorType = try container.decode(String.self, forKey: .errorType)
        self.errorMessage = try? container.decode(String.self, forKey: .errorMessage)
        self.actionResponse = try? container.decode(String.self, forKey: .actionResponse)
    }

    /// Encode a `PetActionError` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(errorType, forKey: .errorType)
        if errorMessage != nil { try? container.encode(errorMessage, forKey: .errorMessage) }
        if actionResponse != nil { try? container.encode(actionResponse, forKey: .actionResponse) }
    }
}
