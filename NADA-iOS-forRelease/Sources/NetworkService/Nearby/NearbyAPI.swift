//
//  NearbyAPI.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/04/24.
//

import Foundation
import Moya

public final class NearbyAPI {
    static let shared = NearbyAPI()
    private var nearbyProvider = MoyaProvider<NearbyService>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    func cardNearByFetch(longitde: Double, latitude: Double, completion: @escaping(NetworkResult<Any>) -> Void) {
        nearbyProvider.request(.cardNearByFetch(longitude: longitde, latitude: latitude)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data: data, type: [AroundMeResponse].self)
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postNearByCard(nearByRequest: NearByRequest, completion: @escaping(NetworkResult<Any>) -> Void) {
        nearbyProvider.request(.postNearByCard(nearByRequest: nearByRequest)) { result in
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
