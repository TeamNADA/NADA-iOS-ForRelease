//
//  BasicAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/10/04.
//

import Foundation

import Moya

public class BasicAPI {
    
    // MARK: - JudgeStatus methods
    
    public func judgeStatus<T: Codable>(response: Response, type: T.Type) -> NetworkResult2<GenericResponse<T>> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: response.data) else { return .pathErr }
        
        switch response.statusCode {
        case 200..<300:
            if decodedData.status >= 400 {
                return .success(decodedData)
            } else {
                return .success(decodedData)
            }
        case 400..<500:
            return .requestErr
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
