//
//  GroupService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum GroupService {
    case groupListFetch(userID: String)
    case groupDelete(groupID: Int)
    case groupAdd(groupRequest: GroupAddRequest)
    case groupEdit(groupRequest: GroupEditRequest)
    case cardAddInGroup(cardRequest: CardAddInGroupRequest)
    case cardListFetch(cardListRequest: CardListRequest)
}

extension GroupService: TargetType {
    
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .groupListFetch:
            return "/groups"
        case .groupDelete(let groupID):
            return "/group/\(groupID)"
        case .groupAdd:
            return "/group"
        case .groupEdit:
            return "/group"
        case .cardAddInGroup:
            return "/groups/card"
        case .cardListFetch:
            return "/groups/cards"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .groupListFetch:
            return .get
        case .groupDelete:
            return .delete
        case .groupAdd:
            return .post
        case .groupEdit:
            return .put
        case .cardAddInGroup:
            return .post
        case .cardListFetch:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .groupListFetch(let userID):
            return .requestParameters(parameters: ["userId": userID], encoding: URLEncoding.queryString)
        case .groupDelete:
            return .requestPlain
        case .groupAdd(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .groupEdit(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .cardAddInGroup(let cardRequest):
            return .requestJSONEncodable(cardRequest)
        case .cardListFetch(let cardListRequest):
            return .requestParameters(parameters: ["userId": cardListRequest.userId,
                                                   "groupId": cardListRequest.groupId,
                                                   "offset": cardListRequest.offset], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .groupListFetch:
            return ["Content-Type": "application/json"]
        case .groupDelete:
            return ["Content-Type": "application/json"]
        case .groupAdd:
            return ["Content-Type": "application/json"]
        case .groupEdit:
            return ["Content-Type": "application/json"]
        case .cardAddInGroup:
            return ["Content-Type": "application/json"]
        case .cardListFetch:
            return ["Content-Type": "application/json"]
        }
    }
    
}
