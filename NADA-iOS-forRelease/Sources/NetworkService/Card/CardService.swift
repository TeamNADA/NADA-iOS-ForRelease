//
//  CardService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum CardService {
    case cardDetailFetch(cardID: String)
    case cardCreation(request: CardCreationRequest, image: UIImage)
}

extension CardService: TargetType {
    
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .cardDetailFetch(let cardID):
            return "/card/\(cardID)"
        case .cardCreation:
            return "/card"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardDetailFetch:
            return .get
        case .cardCreation:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .cardDetailFetch:
            return .requestPlain
        case .cardCreation(let request, let image):
            
//            var multiPartData: [Moya.MultipartFormData] = []
//
//            let userIDData = request.userID.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(userIDData), name: "userId"))
//            let defaultImageData = "\(request.defaultImage)".data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(defaultImageData), name: "defaultImage"))
//            let titleData = request.title.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(titleData), name: "title"))
//            let nameData = request.name.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(nameData), name: "name"))
//            let birthDateData = request.birthDate.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(birthDateData), name: "birthDate"))
//            let mbtiData = request.mbti.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(mbtiData), name: "mbti"))
//            let instagramData = request.instagram.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(instagramData), name: "instagram"))
//            let linkNameData = request.linkName.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(linkNameData), name: "linkName"))
//            let linkData = request.link.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(linkData), name: "link"))
//            let descriptionData = request.description.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(descriptionData), name: "description"))
//            let isMinchoData = request.isMincho.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(isMinchoData), name: "isMincho"))
//            let isSojuData = request.isSoju.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(isSojuData), name: "isSoju"))
//            let isBoomukData = request.isBoomuk.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(isBoomukData), name: "isBoomuk"))
//            let isSaucedData = request.isSauced.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(isSaucedData), name: "isSauced"))
//            let oneQuestionData = request.oneQuestion.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(oneQuestionData), name: "oneQuestion"))
//            let oneAnswerData = request.oneAnswer.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(oneAnswerData), name: "oneAnswer"))
//            let twoQuestionData = request.twoQuestion.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(twoQuestionData), name: "twoQuestion"))
//            let twoAnswerData = request.twoAnswer.data(using: .utf8) ?? Data()
//            multiPartData.append(MultipartFormData(provider: .data(twoAnswerData), name: "twoAnswer"))
//
//            let imageData = MultipartFormData(provider: .data(image.pngData() ?? Data()), name: "image", fileName: "image", mimeType: "image/png")
//            multiPartData.append(imageData)
//
//            return .uploadMultipart(multiPartData)
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .cardDetailFetch:
            return .none
        case .cardCreation:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    
}
