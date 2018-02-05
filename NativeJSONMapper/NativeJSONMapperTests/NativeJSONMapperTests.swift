//
//  NativeJSONMapperTests.swift
//  NativeJSONMapperTests
//
//  Created by Dima Mishchenko on 05.02.2018.
//  Copyright © 2018 Dima Mishchenko. All rights reserved.
//

import XCTest
@testable import NativeJSONMapper

class NativeJSONMapperTests: XCTestCase {
    
    let mapper = NativeJSONMapper()
    
    struct ObjectToMap: Codable, Equatable {
        var stringValue: String
        var intValue: Int
        
        enum CodingKeys: String, CodingKey {
            case stringValue
            case intValue
        }
        
        static func ==(lhs: ObjectToMap, rhs: ObjectToMap) -> Bool {
            return lhs.stringValue == rhs.stringValue && lhs.intValue == rhs.intValue
        }
    }
    
    
    func testObjectMapping() {
        let jsonDict: [String : Any] = ["stringValue" : "String",
                                        "intValue" : 1]
        
        var model: ObjectToMap?
        
        do {
            model = try mapper.map(jsonDict, to: ObjectToMap.self)
        } catch {
            print(error)
            XCTFail()
        }
        
        let modelResult = ObjectToMap(stringValue: "String", intValue: 1)
        
        XCTAssertEqual(model, modelResult)
    }
    
    func testObjectsArrayMapping() {
        let jsonDict: [[String : Any]] = (0...10).map { ["stringValue" : "String \($0)", "intValue" : $0] }
        
        var models = [ObjectToMap]()
        
        do {
            models = try mapper.map(jsonDict, to: [ObjectToMap].self)
        } catch {
            print(error)
            XCTFail()
        }
        
        let modelsResult = (0...10).map { ObjectToMap(stringValue: "String \($0)", intValue: $0) }
        
        XCTAssertEqual(models, modelsResult)
    }
    
    func testObjectMappingWithJSONString() {
        let jsonDict: Any = "{\"stringValue\" : \"String\", \"intValue\" : 1}"
        
        var model: ObjectToMap?
        
        do {
            model = try mapper.map(jsonDict, to: ObjectToMap.self)
        } catch {
            print(error)
            XCTFail()
        }
        
        let modelResult = ObjectToMap(stringValue: "String", intValue: 1)
        
        XCTAssertEqual(model, modelResult)
    }
    
    func testEcodingToDictionary() {
        let model = ObjectToMap(stringValue: "String", intValue: 1)
        
        var encodeDict: [String: Any]?
        
        do {
            encodeDict = try mapper.encodeToDictionary(model)
        } catch {
            print(error)
            XCTFail()
        }
        
        let resultDict: [String : Any] = ["stringValue" : "String",
                                          "intValue" : 1]
        
        let encodeDictString: String? = encodeDict!["stringValue"] as? String
        let resultDictString: String? = resultDict["stringValue"] as? String

        let encodeDictInt: Int? = encodeDict!["intValue"] as? Int
        let resultDictInt: Int? = resultDict["intValue"] as? Int
        
        XCTAssertTrue(encodeDictString == resultDictString && encodeDictInt == resultDictInt)

    }
    
}
