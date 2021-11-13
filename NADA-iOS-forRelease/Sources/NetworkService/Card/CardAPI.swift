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
    
    func getCardDetailFetch(cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardDetailFetch(cardID: cardID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeGetCardDetailFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postCardCreation(request: CardCreationRequest, image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardCreation(request: request, image: image)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeGetCardDetailFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    func getCardListFetch(userID: String, isList: Bool, offset: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardListFetch(userID: userID, isList: isList, offset: offset)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeGetCardListFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func putCardListEdit(request: CardListEditRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardListEdit(request: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeGetCardDetailFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteCard(cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardDelete(cardID: cardID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeGetCardDetailFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeGetCardDetailFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Card>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.msg)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeGetCardListFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CardListLookUpRequest>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.msg)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
