// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2019 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

import NIO

/// `ContentLengthHeaderFrameEncoder` is responsible for emitting JSON-RPC wire protocol with 'Content-Length'
/// HTTP-like headers as used by for example by LSP (Language Server Protocol).
public final class ContentLengthHeaderFrameEncoder: MessageToByteEncoder {
    /// We'll get handed one message through the `Channel` and ...
    public typealias OutboundIn = ByteBuffer
    /// ... will encode it into a `ByteBuffer`.
    public typealias OutboundOut = ByteBuffer

    private var scratchBuffer: ByteBuffer!

    public init() {
        self.scratchBuffer = ByteBuffer()
    }

    public func encode(data: OutboundIn, out: inout ByteBuffer) throws {
        // Step 1, clear the target buffer (note, we are re-using it so if we get lucky we don't need to
        // allocate at all.
        scratchBuffer.clear()

        // Step 2, write the wire protocol for the header.
        scratchBuffer.writeStaticString("Content-Length: ")
        scratchBuffer.writeString(String(data.readableBytes, radix: 10))
        scratchBuffer.writeStaticString("\r\n\r\n")

        // Step 3, send header and the raw message through the `Channel`.
        if data.readableBytes > 0 {
            out.writeBuffer(&scratchBuffer)
            var payload = data
            out.writeBuffer(&payload)
        } else {
            var payload = data
            out.writeBuffer(&payload)
        }
    }
}

/// `ContentLengthHeaderFrameDecoder` is responsible for parsing JSON-RPC wire protocol with 'Content-Length'
/// HTTP-like headers as used by for example by LSP (Language Server Protocol).
public struct ContentLengthHeaderFrameDecoder: ByteToMessageDecoder {
    /// We're emitting one `ByteBuffer` corresponding exactly to one full payload, no headers etc.
    public typealias InboundOut = ByteBuffer

    /// `ContentLengthHeaderFrameDecoder` is a simple state machine.
    private enum State {
        /// either we're waiting for the end of the header block or a new header field, ...
        case waitingForHeaderNameOrHeaderBlockEnd
        /// ... or for a header value, or ...
        case waitingForHeaderValue(name: String)
        /// ... or for the payload of a given size.
        case waitingForPayload(length: Int)
    }

    /// A `DecodingError` is sent through the pipeline if anything went wrong.
    public enum DecodingError: Error, Equatable {
        /// Missing 'Content-Length' header.
        case missingContentLengthHeader

        /// The value of the 'Content-Length' header was illegal, for example a negative number.
        case illegalContentLengthHeaderValue(String)
    }

    public init() {}

    // We start waiting for a header field (or the end of a header block).
    private var state: State = .waitingForHeaderNameOrHeaderBlockEnd
    private var payloadLength: Int?

    // Finishes a header block, most of the time that's very straighforward but we need to verify a few
    // things here.
    private mutating func processHeaderBlockEnd(context: ChannelHandlerContext) throws -> DecodingState {
        if let payloadLength = self.payloadLength {
            if payloadLength == 0 {
                // special case, we're not actually waiting for anything if it's 0 bytes...
                state = .waitingForHeaderNameOrHeaderBlockEnd
                self.payloadLength = nil
                context.fireChannelRead(wrapInboundOut(context.channel.allocator.buffer(capacity: 0)))
                return .continue
            }
            // cool, let's just shift to the `.waitingForPayload` state and continue.
            state = .waitingForPayload(length: payloadLength)
            self.payloadLength = nil
            return .continue
        } else {
            // this happens if we reached the end of the header block but we haven't seen the Content-Length
            // header, that's an error. It will be sent through the `Channel` and decoder won't be called
            // again.
            throw DecodingError.missingContentLengthHeader
        }
    }

    // `decode` will be invoked whenever there is more data available (or if we return `.continue`).
    public mutating func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        switch state {
        case .waitingForHeaderNameOrHeaderBlockEnd:
            // Given that we're waiting for the end of a header block or a new header field, it's sensible to
            // check if this might be the end of the block.
            if buffer.readableBytesView.starts(with: "\r\n".utf8) {
                buffer.moveReaderIndex(forwardBy: 2) // skip \r\n\r\n
                return try processHeaderBlockEnd(context: context)
            }

            // Given that this is not the end of a header block, it must be a new header field. A new header field
            // must always have a colon (or we don't have enough data).
            if let colonIndex = buffer.readableBytesView.firstIndex(of: UInt8(ascii: ":")) {
                let headerName = buffer.readString(length: colonIndex - buffer.readableBytesView.startIndex)!
                buffer.moveReaderIndex(forwardBy: 1) // skip the colon
                state = .waitingForHeaderValue(name: headerName.trimmed().lowercased())
                return .continue
            }

            return .needMoreData
        case let .waitingForHeaderValue(name: headerName):
            // Cool, we're waiting for a header value (ie. we're after the colon).
            // Let's not bother unless we found the whole thing
            guard let newlineIndex = buffer.readableBytesView.firstIndex(of: UInt8(ascii: "\n")) else {
                return .needMoreData
            }

            // Is this a header we actually care about?
            if headerName == "content-length" {
                // Yes, let's parse the int.
                let headerValue = buffer.readString(length: newlineIndex - buffer.readableBytesView.startIndex + 1)!
                if let length = UInt32(headerValue.trimmed()) { // anything more than 4GB or negative doesn't make sense
                    payloadLength = .init(length)
                } else {
                    throw DecodingError.illegalContentLengthHeaderValue(headerValue)
                }
            } else {
                // Nope, let's just skip over it
                buffer.moveReaderIndex(forwardBy: newlineIndex - buffer.readableBytesView.startIndex + 1)
            }

            // but in any case, we're now waiting for a new header or the end of the header block again.
            state = .waitingForHeaderNameOrHeaderBlockEnd
            return .continue
        case let .waitingForPayload(length: length):
            // That's the easiest case, let's just wait until we have enough data.
            if let payload = buffer.readSlice(length: length) {
                // Cool, we got enough data, let's go back waiting for a new header block.
                state = .waitingForHeaderNameOrHeaderBlockEnd
                // And send what we found through the pipeline.
                context.fireChannelRead(wrapInboundOut(payload))
                return .continue
            } else {
                return .needMoreData
            }
        }
    }

    /// Invoked when the `Channel` is being brough down.
    public mutating func decodeLast(
        context: ChannelHandlerContext,
        buffer: inout ByteBuffer,
        seenEOF _: Bool
    ) throws -> DecodingState {
        // Last chance to decode anything.
        while try decode(context: context, buffer: &buffer) == .continue {}

        if buffer.readableBytes > 0 {
            // Oops, there are leftovers that don't form a full message, we could ignore those but it doesn't hurt to send
            // an error.
            throw ByteToMessageDecoderError.leftoverDataWhenDone(buffer)
        }
        return .needMoreData
    }
}
