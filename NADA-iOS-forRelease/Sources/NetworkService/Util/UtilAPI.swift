//
//  UtilAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

//public class UtilAPI {
//
//    static let shared = UtilAPI()
//    var popoProvider = MoyaProvider<UtilService>(plugins: [MoyaLoggerPlugin()])
//
//    public init() { }
//
//    func getTodayFetch(popoID: Int, dayID: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
//        popoProvider.request(.todayFetch(popoID: popoID, dayID: dayID)) { (result) in
//            switch result {
//            case .success(let response):
//                let statusCode = response.statusCode
//                let data = response.data
//
//                let networkResult = self.judgeStatus(by: statusCode, data)
//                completion(networkResult)
//
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
//
//    func patchTodayPatch(popoID: Int, dayID: Int, contentsID: Int, contents: String, completion: @escaping (NetworkResult<Any>) -> Void) {
//        popoProvider.request(.todayPatch(popoID: popoID, dayID: dayID, contentsID: contentsID, contents: contents)) { (result) in
//            switch result {
//            case .success(let response):
//                let statusCode = response.statusCode
//                let data = response.data
//
//                let networkResult = self.judgeStatus(by: statusCode, data)
//                completion(networkResult)
//
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
//
//    func postNewPopo(popoId: Int, contents: NewPopo, image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
//        popoProvider.request(.createTodayPopo(popoId: popoId, contents: contents, image: image)) { (result) in
//            switch result {
//            case .success(let response):
//                let statusCode = response.statusCode
//                let data = response.data
//
//                let networkResult = self.judgeStatus(by: statusCode, data)
//                completion(networkResult)
//
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
//
//    func patchTodayImage(popoId: Int, dayId: Int, image: UIImage, completion: @escaping (NetworkResult<Any>) -> Void) {
//        popoProvider.request(.patchTodayImage(popoId: popoId, dayId: dayId, image: image)) { (result) in
//            switch result {
//            case .success(let response):
//                let statusCode = response.statusCode
//                let data = response.data
//
//                let networkResult = self.judgeStatus(by: statusCode, data)
//                completion(networkResult)
//
//            case .failure(let err):
//                print(err)
//            }
//        }
//    }
//
//    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
//        
//        let decoder = JSONDecoder()
//        guard let decodedData = try? decoder.decode(GenericResponse<PopoToday>.self, from: data)
//        else {
//            return .pathErr
//        }
//
//        switch statusCode {
//        case 200:
//            return .success(decodedData.data)
//        case 400..<500:
//            return .requestErr(decodedData.message)
//        case 500:
//            return .serverErr
//        default:
//            return .networkFail
//        }
//    }
//}
