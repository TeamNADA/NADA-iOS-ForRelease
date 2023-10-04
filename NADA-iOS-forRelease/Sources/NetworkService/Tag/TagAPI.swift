//
//  TagAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/26.
//

import Foundation

import Moya
import RxSwift

public class TagAPI: BasicAPI {
    static let shared = TagAPI()
    var tagProvider = MoyaProvider<TagService>(plugins: [MoyaLoggerPlugin()])
    
    private override init() { }
    
    public func receivedTagFetch(cardUUID: String) -> Single<NetworkResult2<[ReceivedTag]?>> {
        return Single<NetworkResult2<[ReceivedTag]?>>.create { single in
            self.tagProvider.request(.receivedTagFetch(cardUUID: cardUUID)) { result in
                switch result {
                case .success(let response):
                    let networkResult = self.judgeStatus(response: response, type: [ReceivedTag].self)
                    single(.success(networkResult))
                    return
                case .failure(let error):
                    single(.failure(error))
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    public func receivedTagFetch(cardUUID: String, completion: @escaping (NetworkResult<[ReceivedTag]>) -> Void) {
        tagProvider.request(.receivedTagFetch(cardUUID: cardUUID)) { result in
            <#code#>
        }
        
    }
    
    public func TagCreation(request: CreationTagRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.tagCreation(request: request)) { result in
            <#code#>
        }
    }
}
