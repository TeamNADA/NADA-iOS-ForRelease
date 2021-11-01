//
//  UtilService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

//enum UtilService {
//    case todayFetch(popoID: Int, dayID: Int)
//    case todayPatch(popoID: Int, dayID: Int, contentsID: Int, contents: String)
//
//    case createTodayPopo(popoId: Int, contents: NewPopo, image: UIImage)
//    case patchTodayImage(popoId: Int, dayId: Int, image: UIImage)
//}
//
//extension UtilService: TargetType {
//    var baseURL: URL {
//        return URL(string: Const.URL.baseURL)!
//    }
//
//    var path: String {
//        switch self {
//        case .todayFetch(let popoID, let dayID):
//            return "/\(popoID)/tracker/\(dayID)"
//        case .todayPatch(let popoID, let dayID, let contentsID, _):
//            return "/\(popoID)/tracker/\(dayID)/contents/\(contentsID)"
//        case .createTodayPopo(let popoId, _, _):
//            return "/\(popoId)/tracker"
//        case .patchTodayImage(let popoId, let dayId, _):
//            return "/\(popoId)/tracker/\(dayId)/image"
//        }
//    }
//
//    var method: Moya.Method {
//        switch self {
//        case .todayFetch:
//            return .get
//        case .todayPatch:
//            return .patch
//        case .createTodayPopo(_, _, _):
//            return .post
//        case .patchTodayImage(_, _, _):
//            return .patch
//        }
//    }
//
//    var task: Task {
//        switch self {
//        case .todayFetch:
//            return .requestPlain
//        case .todayPatch(_, _, let contentsID, let contents):
//            return .requestParameters(parameters: [
//                "id": contentsID,
//                "contents": contents
//            ], encoding: JSONEncoding.default)
//
//        case .createTodayPopo(let popoId, let contents, let image):
//
//            var options: [[String: Any]] = []
//
//            var multiPartFormData: [Moya.MultipartFormData] = []
//
//            let idJsondata = "\(popoId)".data(using: String.Encoding.utf8) ?? Data()
//            multiPartFormData.append(MultipartFormData(provider: .data(idJsondata), name: "popoId"))
//
//            let dateJsondata = contents.date.data(using: String.Encoding.utf8) ?? Data()
//            multiPartFormData.append(MultipartFormData(provider: .data(dateJsondata), name: "date"))
//
//            for (idx, option) in contents.options.enumerated() {
//
//                let optionIdJsondata = "\(option.optionId)".data(using: String.Encoding.utf8) ?? Data()
//                multiPartFormData.append(MultipartFormData(provider: .data(optionIdJsondata), name: "options[\(idx)].optionId"))
//
//                let optionContentsJsondata = "\(option.contents)".data(using: String.Encoding.utf8) ?? Data()
//                multiPartFormData.append(MultipartFormData(provider: .data(optionContentsJsondata), name: "options[\(idx)].contents"))
//
//            }
//
//            let imageData = image.pngData()
//            let imgData = MultipartFormData(provider: .data(imageData!), name: "image", fileName: "image", mimeType: "image/png")
//            multiPartFormData.append(imgData)
//
//            return .uploadMultipart(multiPartFormData)
//        case .patchTodayImage(_, _, let image):
//            let imageData = image.pngData()
//            let imgData = MultipartFormData(provider: .data(imageData!), name: "image", fileName: "image", mimeType: "image/png")
//            return .uploadMultipart([imgData])
//        }
//    }
//
//    var headers: [String: String]? {
//        switch self {
//        case .todayFetch:
//            return .none
//        case .todayPatch:
//            return ["Content-Type": "application/json"]
//        case .createTodayPopo(_, _, _):
//            return [
//                "Content-Type": "multipart/form-data",
//                "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoidGVzdEB0ZXN0LmNvbSIsImlhdCI6MTYyOTExMjcyNCwiZXhwIjoxNjMxNzA0NzI0LCJpc3MiOiJmb3J0aWNlIn0.CkrwwZe7sJ9RxLbkbbeIz-w4fs2AkQ-FrERDcZNQI2E"
//            ]
//        case .patchTodayImage:
//            return [
//                "Content-Type": "multipart/form-data",
//                "Authorization": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsImVtYWlsIjoidGVzdEB0ZXN0LmNvbSIsImlhdCI6MTYyOTExMjcyNCwiZXhwIjoxNjMxNzA0NzI0LCJpc3MiOiJmb3J0aWNlIn0.CkrwwZe7sJ9RxLbkbbeIz-w4fs2AkQ-FrERDcZNQI2E"
//            ]
//        }
//    }
//}
