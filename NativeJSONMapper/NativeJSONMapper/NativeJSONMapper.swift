//
//  NativeJSONMapper.swift
//  NativeJSONMapper
//
//  Created by Dima Mishchenko on 05.02.2018.
//  Copyright © 2018 Dima Mishchenko. All rights reserved.
//

import UIKit

public enum NativeJSONMapperError: Error {
    case invalidJson(Any)
    case mappingError
}

extension NativeJSONMapperError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidJson(let json):
            return "Invalid JSON: \(json)"
        case .mappingError:
            return "Mapping error."
        }
    }
}

public class NativeJSONMapper
{
    private var decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    public func map<T: Decodable>(_ value: Any, to type: T.Type) throws -> T {
        if let value = value as? String {
            return try map(string: value, to: type)
        } else {
            return try map(json: value, to: type)
        }
    }
    
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        return try JSONEncoder().encode(value)
    }
    
    public func encodeToString<T: Encodable>(_ value: T) throws -> String? {
        do {
            let jsonData = try encode(value)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            throw error
        }
    }
    
    public func encodeToDictionary<T: Encodable>(_ value: T) throws -> [String : Any]? {
        do {
            let jsonString = try encodeToString(value)
            return try jsonString?.convertToDictionary()
        } catch {
            throw error
        }
    }
    
    //MARK: Private
    
    private func map<T: Decodable>(string: String, to type: T.Type) throws -> T {
        if let jsonData = string.data(using: .utf8) {
            return try decoder.decode(type, from: jsonData)
        } else {
            throw NativeJSONMapperError.invalidJson(string)
        }
    }
    
    private func map<T: Decodable>(json: Any, to type: T.Type) throws -> T {
        var model: T?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            model = try decoder.decode(type, from: jsonData)
        } catch {
            throw error
        }
        if let model = model {
            return model
        } else {
            throw NativeJSONMapperError.mappingError
        }
    }
}

extension String {
    
    func convertToDictionary() throws -> [String: Any] {
        if let data = self.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    return json
                } else {
                    throw NativeJSONMapperError.mappingError
                }
            } catch {
                throw error
            }
        } else {
            throw NativeJSONMapperError.invalidJson(self)
        }
    }
}
