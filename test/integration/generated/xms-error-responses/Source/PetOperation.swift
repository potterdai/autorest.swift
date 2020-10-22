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

public final class PetOperation {
    public let client: XmsErrorResponseExtensionsClient

    public let commonOptions: AzureClientOptions

    /// Options provided to configure this `XmsErrorResponseExtensionsClient`.
    public let options: XmsErrorResponseExtensionsClientOptions

    init(client: XmsErrorResponseExtensionsClient) {
        self.client = client
        self.options = client.options
        self.commonOptions = client.commonOptions
    }

    public func url(forTemplate templateIn: String, withKwargs kwargs: [String: String]? = nil) -> URL? {
        return client.url(forTemplate: templateIn, withKwargs: kwargs)
    }

    public func request(
        _ request: HTTPRequest,
        context: PipelineContext?,
        completionHandler: @escaping HTTPResultHandler<Data?>
    ) {
        return client.request(request, context: context, completionHandler: completionHandler)
    }

    /// Gets pets by id.
    /// - Parameters:
    ///    - petId : pet id
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getPetById(
        petId: String,
        withOptions options: GetPetByIdOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Pet?>
    ) {
        // Construct URL
        guard let urlTemplate = "/errorStatusCodes/Pets/{petId}/GetPet".removingPercentEncoding else {
            self.options.logger.error("Failed to construct url")
            return
        }
        let pathParams = [
            "petId": petId
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        let queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Construct request
        guard let requestUrl = url.appendingQueryParameters(queryParams) else {
            self.options.logger.error("Failed to append query parameters to url")
            return
        }

        guard let request = try? HTTPRequest(method: .get, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200, 202, 400, 404, 501] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.sdk("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.sdk("Expected a status code in response but didn't find one.")
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
                        let decoded = try decoder.decode(Pet.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                        }
                    }
                }
                if [
                    202
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(nil),
                            httpResponse
                        )
                    }
                }
                if [
                    400
                ].contains(statusCode) {
                    let decoded = String(data: data, encoding: .utf8)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                }
                if [
                    404
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(NotFoundErrorBase.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                        }
                    }
                }
                if [
                    501
                ].contains(statusCode) {
                    if let decodedstr = String(data: data, encoding: .utf8),
                        let decoded = Int32(decodedstr) {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                        }
                    } else {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", nil)), httpResponse)
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

    /// Asks pet to do something
    /// - Parameters:
    ///    - whatAction : what action the pet should do
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func doSomething(
        whatAction: String,
        withOptions options: DoSomethingOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<PetAction>
    ) {
        // Construct URL
        guard let urlTemplate = "/errorStatusCodes/Pets/doSomething/{whatAction}".removingPercentEncoding else {
            self.options.logger.error("Failed to construct url")
            return
        }
        let pathParams = [
            "whatAction": whatAction
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        let queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Construct request
        guard let requestUrl = url.appendingQueryParameters(queryParams) else {
            self.options.logger.error("Failed to append query parameters to url")
            return
        }

        guard let request = try? HTTPRequest(method: .post, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200, 500] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.sdk("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.sdk("Expected a status code in response but didn't find one.")
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
                        let decoded = try decoder.decode(PetAction.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                        }
                    }
                }
                if [
                    500
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(PetActionError.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                        }
                    }
                }
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(PetActionError.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }
}
