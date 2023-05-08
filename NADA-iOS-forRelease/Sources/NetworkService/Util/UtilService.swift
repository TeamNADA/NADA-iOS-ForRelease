//
//  UtilService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum UtilService {
    case cardHarmonyFetch(cardUUID: String)
}

extension UtilService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .cardHarmonyFetch:
            return .bearer
        }
    }
    
    var path: String {
        switch self {
        case .cardHarmonyFetch(let cardUUID):
            return "/card/compatibility/\(cardUUID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardHarmonyFetch:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .cardHarmonyFetch:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardHarmonyFetch:
            return Const.Header.bearerHeader()
        }
    }
}
