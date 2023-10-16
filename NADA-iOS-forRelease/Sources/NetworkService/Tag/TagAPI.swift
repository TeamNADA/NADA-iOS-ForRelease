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
    
    public func tagFetch() -> Single<NetworkResult2<GenericResponse<[Tag]>>> {
        return Single<NetworkResult2<GenericResponse<[Tag]>>>.create { [weak self] single in
            self?.tagProvider.request(.tagFetch) { result in
                switch result {
                case .success(let response):
                    let networkResult = self?.judgeStatus(response: response, type: [Tag].self)
                    if let networkResult {
                        single(.success(networkResult))
                        return
                    }
                case .failure(let error):
                    single(.failure(error))
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    public func tagCreation(request: CreationTagRequest) -> Single<NetworkResult2<GenericResponse<ReceivedTag>>> {
        return Single<NetworkResult2<GenericResponse<ReceivedTag>>>.create { [weak self] single in
            self?.tagProvider.request(.tagCreation(request: request)) { result in
                switch result {
                case .success(let response):
                    let networkResult = self?.judgeStatus(response: response, type: ReceivedTag.self)
                    if let networkResult {
                        single(.success(networkResult))
                        return
                    }
                case .failure(let error):
                    single(.failure(error))
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    public func tagDeletion(request: [TagDeletionRequest]) -> Single<NetworkResult2<GenericResponse<String>>> {
        return Single<NetworkResult2<GenericResponse<String>>>.create { [weak self] single in
            self?.tagProvider.request(.tagDelete(request: request)) { result in
                switch result {
                case .success(let response):
                    let networkResult = self?.judgeStatus(response: response, type: String.self)
                    if let networkResult {
                        single(.success(networkResult))
                        return
                    }
                case .failure(let error):
                    single(.failure(error))
                    return
                }
            }
            return Disposables.create()
        }
    }
        }
    }
}
