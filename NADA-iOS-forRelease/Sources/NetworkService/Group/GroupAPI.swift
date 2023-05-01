//
//  GroupAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

public class GroupAPI {

    static let shared = GroupAPI()
    var groupProvider = MoyaProvider<GroupService>(plugins: [MoyaLoggerPlugin()])

    public init() { }
    
    func cardDeleteInGroup(groupID: Int, cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardDeleteInGroup(groupID: groupID, cardID: cardID)) { (result) in
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
    
    func groupListFetch(completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupListFetch) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: [String].self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func groupDelete(cardGroupName: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupDelete(cardGroupName: cardGroupName)) { (result) in
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
    
    func groupAdd(groupRequest: GroupAddRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupAdd(groupRequest: groupRequest)) { (result) in
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
    
    func groupEdit(groupRequest: GroupEditRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupEdit(groupRequest: groupRequest)) { (result) in
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
    
    func cardAddInGroup(cardRequest: CardAddInGroupRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardAddInGroup(cardRequest: cardRequest)) { (result) in
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
    
    func cardListFetchInGroup(cardListInGroupRequest: CardListInGroupRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardListFetchInGroup(cardListInGroupRequest: cardListInGroupRequest)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: [Card].self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func groupReset(completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupReset) { (result) in
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
