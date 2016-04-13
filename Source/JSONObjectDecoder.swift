// JSONObjectDecoder.swift
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


public struct JSONObjectDecoder {
	private var dictionary: [String: JSON]
	
	public init(_ dictionary: [String: JSON]) {
		self.dictionary = dictionary
	}
	
	public func child(key: String) throws -> JSON {
		guard let valueJSON = dictionary[key] else {
			throw JSONDecodeError.childNotFound(key: key)
		}
		
		return valueJSON
	}
	
	public func optional(key: String) -> JSON? {
		switch dictionary[key] {
		case .None:
			return nil
		case .NullValue?:
			return nil
		case let child:
			return child
		}
	}
	
	public func decode<Decoded: JSONDecodable>(key: String) throws -> Decoded {
		guard let childJSON = dictionary[key] else {
			throw JSONDecodeError.childNotFound(key: key)
		}
		
		do {
			return try Decoded(sourceJSON: childJSON)
		}
		catch let error as JSONDecodeError {
			throw JSONDecodeError.invalidTypeForChild(key: key, decodedType: String(Decoded), underlyingError: error)
		}
	}
	
	public func decodeOptional<Decoded: JSONDecodable>(key: String) throws -> Decoded? {
		do {
			return try optional(key).map{ try Decoded(sourceJSON: $0) }
		}
		catch let error as JSONDecodeError {
			throw JSONDecodeError.invalidTypeForChild(key: key, decodedType: String(Decoded), underlyingError: error)
		}
	}
	
	public func decodeChoices<T>(decoders: ((JSONObjectDecoder) throws -> T)...) throws -> T {
		var underlyingErrors = [JSONDecodeError]()
		
		for decoder in decoders {
			do {
				return try decoder(self)
			}
			catch let error as JSONDecodeError where error.notFound {
				underlyingErrors.append(error)
			}
		}
		
		throw JSONDecodeError.noCasesFound(sourceType: String(T.self), underlyingErrors: underlyingErrors)
	}
}


extension JSON {
	public var objectDecoder: JSONObjectDecoder? {
		return dictionaryValue.map(JSONObjectDecoder.init)
	}
}


public protocol JSONObjectRepresentable : JSONRepresentable {
	init(source: JSONObjectDecoder) throws
}

extension JSONObjectRepresentable {
	public init(sourceJSON: JSON) throws {
		guard case let .ObjectValue(dictionary) = sourceJSON else {
			throw JSONDecodeError.invalidType(decodedType: String(Self), sourceJSON: sourceJSON)
		}
		
		let source = JSONObjectDecoder(dictionary)
		try self.init(source: source)
	}
}
