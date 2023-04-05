//
//  UpdateService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/04/05.
//

import Foundation

import Moya

enum UpdateService {
    case updateUserInfoFetch
    case updateNoteFetch
}

extension UpdateService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var path: String {
        switch self {
        case .updateUserInfoFetch:
            return "/app/update/note"
        case .updateNoteFetch:
            return "/app/update"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateUserInfoFetch, .updateNoteFetch:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateUserInfoFetch, .updateNoteFetch:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .updateUserInfoFetch, .updateNoteFetch:
            return Const.Header.bearerHeader()
        }
    }
}
