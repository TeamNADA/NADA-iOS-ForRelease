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
    
    func cardHarmonyFetch(myCard: String, yourCard: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        utilProvider.request(.cardHarmonyFetch(myCard: myCard, yourCard: yourCard)) { (result) in
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
        guard let decodedData = try? decoder.decode(GenericResponse<HarmonyResponse>.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.msg)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
