//
//  UtilAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

public class UtilAPI {

    static let shared = UtilAPI()
    var utilProvider = MoyaProvider<UtilService>(plugins: [MoyaLoggerPlugin()])
    
    public init() { }
    
    func cardHarmonyFetch(cardUUID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        utilProvider.request(.cardHarmonyFetch(cardUUID: cardUUID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: HarmonyResponse.self)
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
            if decodedData.status == 404 {
                return .requestErr(decodedData.message ?? "error message")
            } else {
                return .success(decodedData.data ?? "None-Data")
            }
        case 400..<500:
            print("🇰🇷🇰🇷🇰🇷🇰🇷")
            return .requestErr(decodedData.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
