//
//  UtilService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum UtilService {
    case cardHarmonyFetch(myCard: String, yourCard: String)
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
        case .cardHarmonyFetch:
            return "/card/util"
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
        case .cardHarmonyFetch(let myCard, let yourCard):
            return .requestParameters(parameters: ["myCard": myCard,
                                                   "yourCard": yourCard],
                                                   encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardHarmonyFetch:
            return Const.Header.bearerHeader
        }
    }
}
