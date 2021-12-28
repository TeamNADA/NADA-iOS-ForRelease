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
    case userLogout(token: String)
    case userTokenReissue(request: UserTokenReissueRequset)
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
        case .userLogout:
            return "auth/logout"
        case .userTokenReissue:
            return "auth/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userIDFetch, .userTokenFetch:
            return .get
        case .userSignUp, .userSocialSignUp, .userTokenReissue:
            return .post
        case .userDelete, .userLogout:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .userIDFetch, .userTokenFetch, .userDelete, .userLogout:
            return .requestPlain
        case .userSignUp(let request):
            return .requestJSONEncodable(request)
        case .userSocialSignUp(let userID):
            return .requestParameters(parameters: ["userId": userID], encoding: JSONEncoding.default)
        case .userTokenReissue(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .userIDFetch, .userTokenFetch:
            return Const.Header.bearerHeader
        case .userSignUp, .userSocialSignUp, .userTokenReissue:
            return ["Content-Type": "application/json"]
        case .userDelete, .userLogout:
            return Const.Header.basicHeader
        }
    }
}
