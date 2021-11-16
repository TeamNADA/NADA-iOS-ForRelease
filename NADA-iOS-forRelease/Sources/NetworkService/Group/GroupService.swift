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
    case cardListInGroupFetch(cardListInGroupRequest: CardListInGroupRequest)
    case changeCardGroup(request: ChangeGroupRequest)
    case cardInGroupDelete(groupID: Int, cardID: String)
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
        case .cardListInGroupFetch:
            return "/groups/cards"
        case .changeCardGroup:
            return "/groups/card"
        case .cardInGroupDelete(let groupID, let cardID):
            return "/group/\(groupID)/\(cardID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .groupListFetch, .cardListInGroupFetch:
            return .get
        case .groupDelete, .cardInGroupDelete:
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
        case .groupDelete, .cardInGroupDelete:
            return .requestPlain
        case .groupAdd(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .groupEdit(let groupRequest):
            return .requestJSONEncodable(groupRequest)
        case .cardAddInGroup(let cardRequest):
            return .requestJSONEncodable(cardRequest)
        case .cardListInGroupFetch(let cardListInGroupRequest):
            return .requestParameters(parameters: ["userId": cardListInGroupRequest.userId,
                                                   "groupId": cardListInGroupRequest.groupId,
                                                   "offset": cardListInGroupRequest.offset], encoding: URLEncoding.queryString)
        case .changeCardGroup(let requestModel):
            return .requestJSONEncodable(requestModel)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .groupListFetch, .cardListInGroupFetch, .groupDelete, .cardInGroupDelete:
            return .none
        case .groupAdd, .groupEdit, .cardAddInGroup, .changeCardGroup:
            return ["Content-Type": "application/json"]
        }
    }
}
