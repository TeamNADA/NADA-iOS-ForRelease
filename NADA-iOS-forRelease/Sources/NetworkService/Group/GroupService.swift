//
//  GroupService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum GroupService {
    case groupListFetch
    case groupDelete(groupID: Int, defaultGroupId: Int)
    case groupAdd(groupRequest: GroupAddRequest)
    case groupEdit(groupRequest: GroupEditRequest)
    case cardAddInGroup(cardRequest: CardAddInGroupRequest)
    case cardListFetchInGroup(cardListInGroupRequest: CardListInGroupRequest)
    case cardDeleteInGroup(groupID: Int, cardID: String)
    case groupReset(token: String)
}

extension GroupService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .groupListFetch, .cardListFetchInGroup, .groupDelete, .cardDeleteInGroup:
            return .bearer
        case .groupAdd, .groupEdit, .cardAddInGroup, .groupReset:
            return .bearer
        }
    }
    
    var path: String {
        switch self {
        case .groupListFetch, .groupReset:
            return "/card-group/list"
        case .groupDelete(let groupID, _):
            return "/group/\(groupID)"
        case .groupAdd, .groupEdit:
            return "/card-group"
        case .cardAddInGroup:
            return "/card-group/mapping"
        case .cardListFetchInGroup(let cardListInGroupRequest):
            return "/card-group/\(cardListInGroupRequest.cardGroupId)/cards"
        case .cardDeleteInGroup(let groupID, let cardID):
            return "/group/\(groupID)/\(cardID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .groupListFetch, .cardListFetchInGroup:
            return .get
        case .groupDelete, .cardDeleteInGroup, .groupReset:
            return .delete
        case .groupAdd, .cardAddInGroup:
            return .post
        case .groupEdit:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .groupListFetch:
            return .requestPlain
        case .cardDeleteInGroup, .groupReset:
            return .requestPlain
        case .groupDelete(_, let defaultGroupId):
            return .requestParameters(parameters: ["defaultGroupId": defaultGroupId],
                                      encoding: URLEncoding.queryString)
        case .groupAdd(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .groupEdit(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .cardAddInGroup(let gorupRequest):
            return .requestParameters(parameters: ["cardGroupId": gorupRequest.cardGroupID,
                                                   "cardUUID" : gorupRequest.cardUUID],
                                      encoding: JSONEncoding.default)
        case .cardListFetchInGroup(let cardListInGroupRequest):
            return .requestParameters(parameters: ["pageNo": cardListInGroupRequest.pageNo,
                                                   "pageSize": cardListInGroupRequest.pageSize], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .groupListFetch, .cardListFetchInGroup, .groupReset, .groupDelete, .cardDeleteInGroup:
            return Const.Header.bearerHeader()
        case .groupAdd, .groupEdit, .cardAddInGroup:
            return Const.Header.basicHeader()
        }
    }
}
