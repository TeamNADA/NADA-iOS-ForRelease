//
//  UserAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

public class UserAPI {
    
    static let shared = UserAPI()
    var userProvider = MoyaProvider<UserSevice>(plugins: [MoyaLoggerPlugin()])
    
    public init() { }
    
    func getUserIDFetch(userID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userIDFetch(userID: userID)) { (result) in
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
        guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data)
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
