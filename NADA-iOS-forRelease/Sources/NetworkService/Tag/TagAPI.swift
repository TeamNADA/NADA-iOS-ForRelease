//
//  TagAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/26.
//

import Foundation

import Moya
import RxSwift

public class TagAPI {
    static let shared = TagAPI()
    var tagProvider = MoyaProvider<TagService>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    func tagFetch(completion: @escaping (NetworkResult<[Tag]>) -> Void) {
        tagProvider.request(.tagFetch) { result in
            <#code#>
        }
    }
    
    func receivedTagFetch(cardUUID: String, completion: @escaping (NetworkResult<[ReceivedTag]>) -> Void) {
        tagProvider.request(.receivedTagFetch(cardUUID: cardUUID)) { result in
            <#code#>
        }
        
    }
    
    func TagCreation(request: CreationTagRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.tagCreation(request: request)) { result in
            <#code#>
        }
    }
}
