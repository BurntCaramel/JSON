// FoundationExtensions.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Patrick Smith
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation


extension JSONObjectDecoder {
	func decodeUUID(key: String) throws -> NSUUID {
		return try child(key).decodeStringUsing(NSUUID.init)
	}
	
	func decodeData(key: String) throws -> NSData {
		return try child(key).decodeStringUsing{ NSData(base64EncodedString: $0, options: .IgnoreUnknownCharacters) }
	}
	
	func decodeURL(key: String) throws -> NSURL {
		return try child(key).decodeStringUsing{ NSURL(string: $0) }
	}
}

extension NSUUID : JSONEncodable {
	public func toJSON() -> JSON {
		return .StringValue(UUIDString)
	}
}

extension NSData : JSONEncodable {
	public func toJSON() -> JSON {
		return .StringValue(base64EncodedStringWithOptions([]))
	}
}

extension NSURL : JSONEncodable {
	public func toJSON() -> JSON {
		return .StringValue(absoluteString)
	}
}
