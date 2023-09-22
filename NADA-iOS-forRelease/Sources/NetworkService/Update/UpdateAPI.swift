//
//  UpdateAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/04/05.
//

import Foundation

import Moya

public final class UpdateAPI {
    static let shared = UpdateAPI()
    private var updateProvider = MoyaProvider<UpdateService>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    func updateNoteFetch(completion: @escaping(NetworkResult<Any>) -> Void) {
        updateProvider.request(.updateNoteFetch) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: UpdateNote.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func updateUserInfoFetch(completion: @escaping (NetworkResult<Any>) -> Void) {
        updateProvider.request(.updateUserInfoFetch) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: UpdateUserInfo.self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func checkUpdateNote(isChecked: Bool, completion: @escaping (NetworkResult<Any>) -> Void) {
        updateProvider.request(.checkUpdateNote(isChecked: isChecked)) { result in
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
    
    func bannerFetch(completion: @escaping (NetworkResult<Any>) -> Void) {
        updateProvider.request(.bannerFetch) { result in
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
    
    // MARK: - judgeStatus methods
    
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
