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
    
    func cardDetailFetch(cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardDetailFetch(cardID: cardID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeCardDetailFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func cardCreation(request: CardCreationRequest, image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardCreation(request: request, image: image)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeCardCreationStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    func cardListFetch(userID: String, isList: Bool, offset: Int?, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardListFetch(userID: userID, isList: isList, offset: offset)) { (result) in
            if isList == true {
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    let data = response.data
                    
                    let networkResult = self.judgeCardListFetchStatus(by: statusCode, data)
                    completion(networkResult)
                    
                case .failure(let err):
                    print(err)
                }
            } else {
                switch result {
                case .success(let response):
                    let statusCode = response.statusCode
                    let data = response.data
                    
                    let networkResult = self.judgeMainListFetchStatus(by: statusCode, data)
                    completion(networkResult)
                    
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func cardListEdit(request: CardListEditRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardListEdit(request: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func cardDelete(cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        cardProvider.request(.cardDelete(cardID: cardID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data)
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
                let networkResult = self.judgeStatus(by: statusCode, data)
                
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    private func judgeCardDetailFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CardClass>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.error?.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeMainListFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CardListLookUp>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.error?.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeCardListFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CardListRequest>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.error?.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeCardCreationStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Card>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 201:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.error?.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.error?.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
