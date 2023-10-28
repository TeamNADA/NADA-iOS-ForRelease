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
    
    func receivedTagFetch(cardUUID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        tagProvider.request(.receivedTagFetch(cardUUID: cardUUID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data: data, type: [ReceivedTag].self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    public func receivedTagFetch(cardUUID: String) -> Single<NetworkResult2<GenericResponse<[ReceivedTag]>>> {
        return Single<NetworkResult2<GenericResponse<[ReceivedTag]>>>.create { single in
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
    
    public func tagFiltering(query: String) -> Single<NetworkResult2<GenericResponse<Bool>>> {
        return Single<NetworkResult2<GenericResponse<Bool>>>.create { [weak self] single in
            self?.tagProvider.request(.tagFiltering(query: query)) { result in
                switch result {
                case .success(let response):
                    let networkResult = self?.judgeStatus(response: response, type: Bool.self)
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
