//
//  JsonDecoderService.swift
//  SnapChef
//
//  Created by DonHalab on 02.02.2025.
//

import Foundation

enum DecodingCustomError: Error {
    case invalidData
    case parsingFailed(underlyingError: Error)
}

protocol DecoderServiceProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws(DecodingCustomError) -> T
}

struct DecoderService: DecoderServiceProtocol {
    
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func decode<T>(_ type: T.Type, from data: Data) throws(DecodingCustomError) -> T where T : Decodable {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw DecodingCustomError.parsingFailed(underlyingError: error)
        }
    }
}
