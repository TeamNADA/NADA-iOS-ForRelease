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
    case postNearByCard(nearByRequest: NearByRequest)
    case nearByUUIDFetch(cardUUID: String)
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
            return "/v1/card/nearby/point/longitude/\(longitude)/latitude/\(latitude)"
        case .postNearByCard:
            return "/v1/card/nearby"
        case .nearByUUIDFetch(let cardUUID):
            return "/v1/card/nearby/\(cardUUID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardNearByFetch, .nearByUUIDFetch:
            return .get
        case .postNearByCard:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .cardNearByFetch, .nearByUUIDFetch:
            return .requestPlain
        case .postNearByCard(let nearByRequest):
            return .requestParameters(parameters: ["cardUuid": nearByRequest.cardUUID,
                                                   "isActive": nearByRequest.isActive,
                                                   "latitude": nearByRequest.latitude,
                                                   "longitude": nearByRequest.longitude],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardNearByFetch, .postNearByCard, .nearByUUIDFetch:
            return Const.Header.bearerHeader()
        }
    }
}
