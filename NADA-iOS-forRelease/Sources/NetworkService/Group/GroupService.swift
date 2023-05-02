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
    case groupDelete(cardGroupName: String)
    case groupAdd(groupRequest: GroupAddRequest)
    case groupEdit(groupRequest: GroupEditRequest)
    case cardAddInGroup(cardRequest: CardAddInGroupRequest)
    case cardListFetchInGroup(cardListInGroupRequest: CardListInGroupRequest)
    case cardDeleteInGroup(cardUuid: String, cardGroupName: String)
    case groupReset
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
        case .groupListFetch:
            return "/card-group/list"
        case .groupReset:
            return "/card-group/clear"
        case .groupDelete:
            return "/card-group"
        case .groupAdd:
            return "/card-group"
        case .groupEdit:
            return "/card-group/name"
        case .cardAddInGroup:
            return "/card-group/mapping"
        case .cardListFetchInGroup:
            return "/card-group/cards"
        case .cardDeleteInGroup(let cardUuid, _):
            return "/card-group/card/\(cardUuid)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .groupListFetch, .cardListFetchInGroup:
            return .get
        case .groupDelete, .cardDeleteInGroup:
            return .delete
        case .groupAdd, .cardAddInGroup, .groupReset:
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
        case .groupReset:
            return .requestPlain
        case .cardDeleteInGroup(_, let cardGroupName):
            return .requestParameters(parameters: ["cardGroupName": cardGroupName],
                                      encoding: URLEncoding.queryString)
        case .groupDelete(let cardGroupName):
            return .requestParameters(parameters: ["cardGroupName": cardGroupName],
                                      encoding: URLEncoding.queryString)
        case .groupAdd(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .groupEdit(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .cardAddInGroup(let groupRequest):
            return .requestParameters(parameters: ["cardGroupName": groupRequest.cardGroupName,
                                                   "cardUUID": groupRequest.cardUUID],
                                      encoding: JSONEncoding.default)
        case .cardListFetchInGroup(let cardListInGroupRequest):
            return .requestParameters(parameters: ["pageNo": cardListInGroupRequest.pageNo,
                                                   "pageSize": cardListInGroupRequest.pageSize,
                                                   "groupName": cardListInGroupRequest.groupName], encoding: URLEncoding.queryString)
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
