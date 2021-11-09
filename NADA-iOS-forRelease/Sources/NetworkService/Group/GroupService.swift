//
//  GroupService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum GroupService {
    case changeCardGroup(request: ChangeGroupRequest)
    case cardInGroupDelete(groupID: Int, cardID: String)
}

extension GroupService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .changeCardGroup:
            return "/groups/card"
        case .cardInGroupDelete(let groupID, let cardID):
            return "/group/\(groupID)/\(cardID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .changeCardGroup:
            return .put
        case .cardInGroupDelete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .changeCardGroup(let requestModel):
            return .requestJSONEncodable(requestModel)
        case .cardInGroupDelete:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .changeCardGroup:
            return ["Content-Type": "application/json"]
        case .cardInGroupDelete:
            return ["Content-Type": "application/json"]
        }
    }
}
