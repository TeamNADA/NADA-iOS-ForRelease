//
//  GenericResult.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let error: NetworkError?
    let status: Int
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case error
        case status
        case data = "result"
    }
}

struct NetworkError: Codable {
    let code: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}
