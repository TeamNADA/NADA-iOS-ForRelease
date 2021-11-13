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
    case userTokenFetch(userID: String)
    case userSignUp(request: User)
    case userDelete(userID: String)
}

extension UserSevice: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }

    var path: String {
        switch self {
        case .userIDFetch(let userID):
            return "/\(userID)/login"
        case .userTokenFetch(let userID):
            return "/auth/\(userID)/login"
        case .userSignUp:
            return "/register"
        case .userDelete(let userID):
            return "/\(userID)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .userIDFetch:
            return .get
        case .userTokenFetch:
            return .get
        case .userSignUp:
            return .post
        case .userDelete:
            return .delete
        }
    }

    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .userIDFetch:
            return .requestPlain
        case .userTokenFetch:
            return .requestPlain
        case .userSignUp(let request):
            return .requestJSONEncodable(request)
        case .userDelete:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .userIDFetch:
            return ["Content-Type": "application/json"]
        case .userTokenFetch:
            return ["Content-Type": "application/json"]
        case .userSignUp:
            return ["Content-Type": "application/json"]
        case .userDelete:
            return ["Content-Type": "application/json"]
        }
    }
}
