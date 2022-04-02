//
//  UserSevice.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum UserSevice {
    case userDelete(token: String)
    case userSocialSignUp(userID: String)
    case userLogout(token: String)
    case userTokenReissue(request: UserReissueToken)
}

extension UserSevice: TargetType {

    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
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
        case .userSocialSignUp, .userTokenReissue:
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
        case .userDelete, .userLogout:
            return .requestPlain
        case .userSocialSignUp(let userID):
            return .requestParameters(parameters: ["userId": userID], encoding: JSONEncoding.default)
        case .userTokenReissue(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .userSocialSignUp, .userTokenReissue:
            return Const.Header.applicationJsonHeader()
        case .userDelete, .userLogout:
            return Const.Header.bearerHeader()
        }
    }
}
