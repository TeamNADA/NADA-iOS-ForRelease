//
//  CardAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

public class CardAPI {
    static let shared = CardAPI()
    var cardProvider = MoyaProvider<CardService>(plugins: [MoyaLoggerPlugin()])
    
    public init() { }
    
    func cardDetailFetch(cardUUID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardDetailFetch(cardUUID: cardUUID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: Card.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func cardCreation(request: CardCreationRequest, type: CreationType = .create, cardUUID: String? = nil, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardCreation(request: request, type: type, cardUUID: cardUUID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeStatus(by: statusCode, data: data, type: Card.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    func cardListFetch(pageNumber: Int? = nil, pageSize: Int? = nil, completion: @escaping (NetworkResult<Any>) -> Void) {
        if let pageNumber, let pageSize {
            cardProvider.request(.cardListPageFetch(pageNumber: pageNumber, pageSize: pageSize)) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    let data = response.data
                    
                    let networkResult = self.judgeStatus(by: statusCode, data: data, type: [Card].self)
                    completion(networkResult)
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            cardProvider.request(.cardListFetch) { result in
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    let data = response.data
                    
                    let networkResult = self.judgeStatus(by: statusCode, data: data, type: [Card].self)
                    completion(networkResult)
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func cardReorder(request: [CardReorderInfo], completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardReorder(request: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: String.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func cardDelete(cardID: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardDelete(cardID: cardID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: String.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func cardImageUpload(image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.imageUpload(image: image)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: String.self)
                
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func tasteFetch(cardType: CardType, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.tasteFetch(cardType: cardType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: Taste.self)
                
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // MARK: - JudgeStatus methods
    
    private func judgeStatus<T: Codable>(by statusCode: Int, data: Data, type: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200:
            if decodedData.status >= 400 {
                return .requestErr(decodedData.message ?? "error message")
            } else {
                return .success(decodedData.data ?? "None-Data")
            }
        case 400..<500:
            return .requestErr(decodedData.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
