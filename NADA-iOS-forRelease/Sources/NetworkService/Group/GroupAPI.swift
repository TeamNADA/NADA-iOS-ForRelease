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

    func changeCardGroup(request: ChangeGroupRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.changeCardGroup(request: request)) { (result) in
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
    
    func cardDeleteInGroup(groupID: Int, cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardDeleteInGroup(groupID: groupID, cardID: cardID)) { (result) in
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
    
    func groupListFetch(userID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupListFetch(userID: userID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeGroupListFetchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func groupDelete(groupID: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupDelete(groupID: groupID)) { (result) in
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
    
    func groupAdd(groupRequest: GroupAddRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupAdd(groupRequest: groupRequest)) { (result) in
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
    
    func groupEdit(groupRequest: GroupEditRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupEdit(groupRequest: groupRequest)) { (result) in
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
    
    func cardAddInGroup(cardRequest: CardAddInGroupRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardAddInGroup(cardRequest: cardRequest)) { (result) in
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
    
    func cardListFetchInGroup(cardListInGroupRequest: CardListInGroupRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardListFetchInGroup(cardListInGroupRequest: cardListInGroupRequest)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeCardListFetchInGroupStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func groupReset(token: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.groupReset(token: token)) { (result) in
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
    
    private func judgeGroupListFetchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<Groups>.self, from: data)
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
    
    private func judgeCardListFetchInGroupStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CardsInGroupResponse>.self, from: data)
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
