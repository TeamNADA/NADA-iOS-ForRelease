//
//  GenericResult.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    var msg: String
    var timestamp: String
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case msg
        case timestamp
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        msg = (try? values.decode(String.self, forKey: .msg)) ?? ""
        timestamp = (try? values.decode(String.self, forKey: .timestamp)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
