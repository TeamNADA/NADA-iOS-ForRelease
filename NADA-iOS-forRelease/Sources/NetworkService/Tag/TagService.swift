//
//  TagService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/26.
//

import Foundation

import Moya

enum TagService {
    case tagCreation(request: CreationTagRequest)
    case tagFetch
    case receivedTagFetch(cardUUID: String)
}

extension TagService: TargetType {
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .tagCreation:
            return "/card/tag"
        case .tagFetch:
            return "/tag/image"
        case .receivedTagFetch(let cardUUID):
            return "/card/tag/card/\(cardUUID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .tagCreation:
            return .post
        case .tagFetch, .receivedTagFetch:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .tagCreation(let request):
            return .requestJSONEncodable(request)
        case .tagFetch, .receivedTagFetch:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .tagCreation:
            return Const.Header.basicHeader()
        case .tagFetch, .receivedTagFetch:
            return Const.Header.bearerHeader()
        }
    }
}
