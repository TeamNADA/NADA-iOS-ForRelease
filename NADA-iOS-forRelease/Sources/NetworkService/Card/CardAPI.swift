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

                let networkResult = self.judgeStatus(by: statusCode, data)
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

                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }

    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
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
}
