//
//  GenericResult.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let code: String?
    let message: String?
    let status: Int
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case code, message, status
        case data = "result"
    }
}
