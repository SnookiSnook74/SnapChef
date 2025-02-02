//
//  DecoderServiceTest.swift
//  SnapChef
//
//  Created by DonHalab on 02.02.2025.
//

import Testing
import Foundation
@testable import SnapChef

struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}

struct DecoderServiceTest {
    
    let decoder = DecoderService()

    @Test("Проверка валидных JSON", arguments: [
        """
        [
            {"id": 1, "name": "Milk"},
            {"id": 2, "name": "Cucumber"}
        ]
        """]
    )
    func vaildJson(json: String) throws {
        let data = Data(json.utf8)
        
        let result = try decoder.decode([TestModel].self, from: data)
        
        let expected = [
            TestModel(id: 1, name: "Milk"),
            TestModel(id: 2, name: "Cucumber")
        ]
        
        #expect(result == expected)
        #expect(result.count == 2)
    }
    
    @Test func invalidJson() {
        let invalidJson = """
        [
            {"id": "1", "name": "Milk",
            {"id": 2, "name": "Cucumber"}
        ]
        """
        let data = Data(invalidJson.utf8)
        
       #expect(throws: DecodingCustomError.self, "Ожидается ошибка декодирования из-за неверного JSON", performing: {
            try decoder.decode([TestModel].self, from: data)
        })
    }
}
