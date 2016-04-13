// SwiftExtensions.swift
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


extension String : JSONRepresentable {
	public init(sourceJSON: JSON) throws {
		if case let .StringValue(value) = sourceJSON {
			self = value
		}
		else {
			throw JSONDecodeError.invalidType(decodedType: String(String), sourceJSON: sourceJSON)
		}
	}
	
	public func toJSON() -> JSON {
		return .StringValue(self)
	}
}

extension Bool : JSONRepresentable {
	public init(sourceJSON: JSON) throws {
		if case let .BooleanValue(value) = sourceJSON {
			self = value
		}
		else {
			throw JSONDecodeError.invalidType(decodedType: String(Bool), sourceJSON: sourceJSON)
		}
	}
	
	public func toJSON() -> JSON {
		return .BooleanValue(self)
	}
}

extension Double : JSONRepresentable {
	public init(sourceJSON: JSON) throws {
		if case let .NumberValue(value) = sourceJSON {
			self = value
		}
		else {
			throw JSONDecodeError.invalidType(decodedType: String(String), sourceJSON: sourceJSON)
		}
	}
	
	public func toJSON() -> JSON {
		return .NumberValue(self)
	}
}

extension Int : JSONRepresentable {
	public init(sourceJSON: JSON) throws {
		if case let .NumberValue(value) = sourceJSON {
			self = Int(value)
		}
		else {
			throw JSONDecodeError.invalidType(decodedType: String(String), sourceJSON: sourceJSON)
		}
	}
	
	public func toJSON() -> JSON {
		return .NumberValue(Double(self))
	}
}

extension Optional where Wrapped : JSONEncodable {
	func toJSON() -> JSON {
		return self?.toJSON() ?? .NullValue
	}
}

extension CollectionType where Generator.Element : JSONEncodable {
	func toJSON() -> JSON {
		return .ArrayValue(map{ $0.toJSON() })
	}
}
