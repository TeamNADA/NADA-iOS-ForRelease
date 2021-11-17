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
    case cardListFetchInGroup(cardListInGroupRequest: CardListInGroupRequest)
    case changeCardGroup(request: ChangeGroupRequest)
    case cardDeleteInGroup(groupID: Int, cardID: String)
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
        case .cardListFetchInGroup:
            return "/groups/cards"
        case .changeCardGroup:
            return "/groups/card"
        case .cardDeleteInGroup(let groupID, let cardID):
            return "/group/\(groupID)/\(cardID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .groupListFetch, .cardListFetchInGroup:
            return .get
        case .groupDelete, .cardDeleteInGroup:
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
        case .groupDelete, .cardDeleteInGroup:
            return .requestPlain
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
            return .none
        case .groupAdd, .groupEdit, .cardAddInGroup, .changeCardGroup:
            return ["Content-Type": "application/json"]
        }
    }
}
