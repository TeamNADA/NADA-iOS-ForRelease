//
//  UserSevice.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum UserSevice {
    case userIDFetch(userID: String)
}

extension UserSevice: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }

    var path: String {
        switch self {
        case .userIDFetch(userID: let userID):
            return "/\(userID)/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .userIDFetch:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .userIDFetch:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .userIDFetch:
            return ["Content-Type": "application/json"]
        }
    }
}
