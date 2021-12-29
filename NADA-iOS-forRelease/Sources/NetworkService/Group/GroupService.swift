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
    case groupDelete(groupID: Int, defaultGroupId: Int)
    case groupAdd(groupRequest: GroupAddRequest)
    case groupEdit(groupRequest: GroupEditRequest)
    case cardAddInGroup(cardRequest: CardAddInGroupRequest)
    case cardListFetchInGroup(cardListInGroupRequest: CardListInGroupRequest)
    case changeCardGroup(request: ChangeGroupRequest)
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
        case .groupAdd, .groupEdit, .cardAddInGroup, .changeCardGroup, .groupReset:
            return .bearer
        }
    }
    
    var path: String {
        switch self {
        case .groupListFetch, .groupReset:
            return "/groups"
        case .groupDelete(let groupID, _):
            return "/group/\(groupID)"
        case .groupAdd, .groupEdit:
            return "/group"
        case .cardAddInGroup, .changeCardGroup:
            return "/groups/card"
        case .cardListFetchInGroup:
            return "/groups/cards"
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
        case .groupEdit, .changeCardGroup:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .groupListFetch(let userID):
            return .requestParameters(parameters: ["userId": userID],
                                      encoding: URLEncoding.queryString)
        case .cardDeleteInGroup, .groupReset:
            return .requestPlain
        case .groupDelete(_, let defaultGroupId):
            return .requestParameters(parameters: ["defaultGroupId": defaultGroupId],
                                      encoding: URLEncoding.queryString)
        case .groupAdd(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .groupEdit(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .cardAddInGroup(let cardRequest):
            return .requestJSONEncodable(cardRequest)
        case .cardListFetchInGroup(let cardListInGroupRequest):
            return .requestParameters(parameters: ["userId": cardListInGroupRequest.userId,
                                                   "groupId": cardListInGroupRequest.groupId,
                                                   "offset": cardListInGroupRequest.offset], encoding: URLEncoding.queryString)
        case .changeCardGroup(let requestModel):
            return .requestJSONEncodable(requestModel)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .groupListFetch, .cardListFetchInGroup, .groupDelete, .cardDeleteInGroup:
            return Const.Header.bearerHeader
        case .groupAdd, .groupEdit, .cardAddInGroup, .changeCardGroup:
            return Const.Header.bearerHeader
        case .groupReset:
            return Const.Header.basicHeader
        }
    }
}
