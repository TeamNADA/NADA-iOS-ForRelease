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
    
    func userSocialSignUp(socialID: String, socialType: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userSocialSignUp(socialID: socialID, socialType: socialType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeUserSocialSignUpStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    func userLogout(token: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userLogout(token: token)) { (result) in
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
    
    func userTokenReissue(request: UserReissueToken, completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.userTokenReissue(request: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeUserTokenReissueStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // MARK: - JudgeStatus methods
    
    private func judgeUserSocialSignUpStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AccessToken>.self, from: data)
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
            return .requestErr(decodedData.error?.message ?? "error message")
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func judgeUserTokenReissueStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<UserReissueToken>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(statusCode)
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
