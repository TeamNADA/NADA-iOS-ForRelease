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
    
    func userDelete(completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userDelete) { (result) in
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
    
    func userSocialSignUp(socialID: String, socialType: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userSocialSignUp(socialID: socialID, socialType: socialType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: AccessToken.self)
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
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
