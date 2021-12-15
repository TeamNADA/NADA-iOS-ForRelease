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
    
    func userIDFetch(userID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userIDFetch(userID: userID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeUserIDFetchStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    func userTokenFetch(userID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userTokenFetch(userID: userID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeUserTokenFetchStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    func userSignUp(request: User, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userSignUp(request: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgeUserIDFetchStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    func userDelete(token: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userDelete(token: token)) { (result) in
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
    
    func userSocialSignUp(request: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userSocialSignUp(userID: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeUserTokenFetchStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeUserIDFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<User>.self, from: data)
        else {
            return .pathErr
        }
        
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
    
    private func judgeUserTokenFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<UserWithTokenRequest>.self, from: data)
        else {
            return .pathErr
        }
        
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
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        case 200:
            return .success(decodedData.msg)
        case 400..<500:
            return .requestErr(decodedData.msg)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
