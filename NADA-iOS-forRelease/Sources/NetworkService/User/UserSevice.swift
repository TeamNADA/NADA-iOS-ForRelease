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
    case userDelete(token: String)
    case userSocialSignUp(userID: String)
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
        case .userDelete:
            return "/user"
        case .userSocialSignUp:
            return "auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userIDFetch, .userTokenFetch:
            return .get
        case .userSignUp, .userSocialSignUp:
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
        case .userIDFetch, .userTokenFetch, .userDelete:
            return .requestPlain
        case .userSignUp(let request):
            return .requestJSONEncodable(request)
        case .userSocialSignUp(let userID):
            return .requestParameters(parameters: ["userId": userID], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .userIDFetch, .userTokenFetch:
            return .none
        case .userSignUp, .userSocialSignUp:
            return ["Content-Type": "application/json"]
        case .userDelete(let token):
            return ["Content-Type": "application/json", "Authorization": "Bearer " + token]
        }
    }
}
