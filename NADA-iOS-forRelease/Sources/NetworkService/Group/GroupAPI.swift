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

    func putChangeGroup(request: ChangeGroupRequest, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.changeCardGroup(request: request)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgePutChangeGroupStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    func deleteCardInGroupDelete(groupID: Int, cardID: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        groupProvider.request(.cardInGroupDelete(groupID: groupID, cardID: cardID)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                let networkResult = self.judgePutChangeGroupStatus(by: statusCode, data)
                completion(networkResult)

            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgePutChangeGroupStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
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
