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
// swiftlint:disable file_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

public final class AutoRestValidationTest {
    public let client: AutoRestValidationTestClient

    init(client: AutoRestValidationTestClient) {
        self.client = client
    }

    /// Validates input parameters on the method. See swagger for details.
    /// - Parameters:
    ///    - resourceGroupName : Required string between 3 and 10 chars with pattern [a-zA-Z0-9]+.
    ///    - id : Required int multiple of 10 from 100 to 1000.
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func validationOfMethodParameters(
        resourceGroupName: String,
        id: Int32,
        withOptions options: ValidationOfMethodParametersOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Product>
    ) {
        let dispatchQueue = options?.dispatchQueue ?? client.commonOptions.dispatchQueue ?? DispatchQueue.main

        // Create request parameters
        let params = RequestParameters(
            (.path, "resourceGroupName", resourceGroupName, .encode), (.path, "id", id, .encode),
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.path, "subscriptionId", client.subscriptionId, .encode),
            (.query, "apiVersion", client.options.apiVersion, .encode), (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/fakepath/{subscriptionId}/{resourceGroupName}/{id}"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers)
        else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }

        // Apply client-side validation
        var validationErrors = [String]()
        // Validate id
        if id % (10 as Int32) != 0 {
            validationErrors.append("id: multipleOf 10")
        }
        if id > 1000 {
            validationErrors.append("id: <= 1000")
        }
        if id < 100 {
            validationErrors.append("id: >= 100")
        }
        // Validate resourceGroupName
        if resourceGroupName.count > 10 {
            validationErrors.append("resourceGroupName: maxLength 10")
        }
        if resourceGroupName.count < 3 {
            validationErrors.append("resourceGroupName: minLength 3")
        }
        if resourceGroupName.range(of: #"[a-zA-Z0-9']+"#, options: .regularExpression) == nil {
            validationErrors.append(#"resourceGroupName: pattern [a-zA-Z0-9']+"#)
        }
        if !validationErrors.isEmpty {
            dispatchQueue.async {
                let error = AzureError.client("Validation Errors: \(validationErrors.joined(separator: ", "))")
                completionHandler(.failure(error), nil)
            }
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }
            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Product.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
                    }
                }
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("Unexpected error", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }

    /// Validates body parameters on the method. See swagger for details.
    /// - Parameters:
    ///    - ofBody :
    ///    - resourceGroupName : Required string between 3 and 10 chars with pattern [a-zA-Z0-9]+.
    ///    - id : Required int multiple of 10 from 100 to 1000.
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func validation(
        ofBody: Product?,
        resourceGroupName: String,
        id: Int32,
        withOptions options: ValidationOfBodyOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Product>
    ) {
        let dispatchQueue = options?.dispatchQueue ?? client.commonOptions.dispatchQueue ?? DispatchQueue.main

        // Create request parameters
        let params = RequestParameters(
            (.path, "resourceGroupName", resourceGroupName, .encode), (.path, "id", id, .encode),
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.path, "subscriptionId", client.subscriptionId, .encode),
            (.query, "apiVersion", client.options.apiVersion, .encode),
            (.header, "Content-Type", "application/json", .encode), (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        var requestBody: Data?
        if ofBody != nil {
            guard let encodedRequestBody = try? JSONEncoder().encode(ofBody) else {
                client.options.logger.error("Failed to encode request body as json.")
                return
            }
            requestBody = encodedRequestBody
        }
        let urlTemplate = "/fakepath/{subscriptionId}/{resourceGroupName}/{id}"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .put, url: requestUrl, headers: params.headers, data: requestBody)
        else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }

        // Apply client-side validation
        var validationErrors = [String]()
        // Validate id
        if id % (10 as Int32) != 0 {
            validationErrors.append("id: multipleOf 10")
        }
        if id > 1000 {
            validationErrors.append("id: <= 1000")
        }
        if id < 100 {
            validationErrors.append("id: >= 100")
        }
        // Validate ofBody?.capacity
        if let value = ofBody?.capacity, value >= 100 {
            validationErrors.append("ofBody?.capacity: < 100")
        }
        if let value = ofBody?.capacity, value <= 0 {
            validationErrors.append("ofBody?.capacity: > 0")
        }
        // Validate ofBody?.displayNames
        if let value = ofBody?.displayNames, value.count > 6 {
            validationErrors.append("ofBody?.displayNames: maxItems 6")
        }
        // Validate ofBody?.image
        if let value = ofBody?.image, value.range(of: #"http://\w+"#, options: .regularExpression) == nil {
            validationErrors.append(#"ofBody?.image: pattern http://\w+"#)
        }
        // Validate resourceGroupName
        if resourceGroupName.count > 10 {
            validationErrors.append("resourceGroupName: maxLength 10")
        }
        if resourceGroupName.count < 3 {
            validationErrors.append("resourceGroupName: minLength 3")
        }
        if resourceGroupName.range(of: #"[a-zA-Z0-9]+"#, options: .regularExpression) == nil {
            validationErrors.append(#"resourceGroupName: pattern [a-zA-Z0-9]+"#)
        }
        if !validationErrors.isEmpty {
            dispatchQueue.async {
                let error = AzureError.client("Validation Errors: \(validationErrors.joined(separator: ", "))")
                completionHandler(.failure(error), nil)
            }
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }
            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Product.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
                    }
                }
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("Unexpected error", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }

    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getWithConstantInPath(
        withOptions options: GetWithConstantInPathOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        let dispatchQueue = options?.dispatchQueue ?? client.commonOptions.dispatchQueue ?? DispatchQueue.main

        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.path, "constantParam", "constant", .encode)
        )

        // Construct request
        let urlTemplate = "/validation/constantsInPath/{constantParam}/value"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers)
        else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
            case let .failure(error):
                dispatchQueue.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }

    /// - Parameters:
    ///    - withConstantInBody :
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func post(
        withConstantInBody: Product?,
        withOptions options: PostWithConstantInBodyOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Product>
    ) {
        let dispatchQueue = options?.dispatchQueue ?? client.commonOptions.dispatchQueue ?? DispatchQueue.main

        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.path, "constantParam", "constant", .encode),
            (.header, "Content-Type", "application/json", .encode), (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        var requestBody: Data?
        if withConstantInBody != nil {
            guard let encodedRequestBody = try? JSONEncoder().encode(withConstantInBody) else {
                client.options.logger.error("Failed to encode request body as json.")
                return
            }
            requestBody = encodedRequestBody
        }
        let urlTemplate = "/validation/constantsInPath/{constantParam}/value"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .post, url: requestUrl, headers: params.headers, data: requestBody)
        else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }

        // Apply client-side validation
        var validationErrors = [String]()
        // Validate withConstantInBody?.capacity
        if let value = withConstantInBody?.capacity, value >= 100 {
            validationErrors.append("withConstantInBody?.capacity: < 100")
        }
        if let value = withConstantInBody?.capacity, value <= 0 {
            validationErrors.append("withConstantInBody?.capacity: > 0")
        }
        // Validate withConstantInBody?.displayNames
        if let value = withConstantInBody?.displayNames, value.count > 6 {
            validationErrors.append("withConstantInBody?.displayNames: maxItems 6")
        }
        // Validate withConstantInBody?.image
        if let value = withConstantInBody?.image, value.range(of: #"http://\w+"#, options: .regularExpression) == nil {
            validationErrors.append(#"withConstantInBody?.image: pattern http://\w+"#)
        }
        if !validationErrors.isEmpty {
            dispatchQueue.async {
                let error = AzureError.client("Validation Errors: \(validationErrors.joined(separator: ", "))")
                completionHandler(.failure(error), nil)
            }
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }
            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Product.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
                    }
                }
            case let .failure(error):
                dispatchQueue.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }
}
