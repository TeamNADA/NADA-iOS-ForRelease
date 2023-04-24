//
//  NearbyService.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/04/24.
//

import Foundation
import Moya

enum NearbyService {
    case cardNearByFetch(longitude: Double, latitude: Double)
}

extension NearbyService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var authorizationType: AuthorizationType? {
        return .bearer
    }
    
    var path: String {
        switch self {
        case .cardNearByFetch(let longitude, let latitude):
            return "/card/nearby/point/longitude/\(longitude)/latitude/\(latitude)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardNearByFetch:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .cardNearByFetch:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardNearByFetch:
            return Const.Header.bearerHeader()
        }
    }
}
