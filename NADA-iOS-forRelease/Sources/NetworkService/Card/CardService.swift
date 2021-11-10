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
    case cardListFetch(userID: String, isList: Bool?, offset: Int?)
    case cardListEdit(request: CardListEditRequest)
    case cardDelete(cardID: String)
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
        case .cardListFetch:
            return "/cards"
        case .cardListEdit:
            return "/cards"
        case .cardDelete(let cardID):
            return "/card/\(cardID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardDetailFetch:
            return .get
        case .cardCreation:
            return .post
        case .cardListFetch:
            return .get
        case .cardListEdit:
            return .put
        case .cardDelete:
            return .delete
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
            
            var multiPartData: [Moya.MultipartFormData] = []
            
            let userIDData = request.userID.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(userIDData), name: "card.userId"))
            let defaultImageData = "\(request.defaultImage)".data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(defaultImageData), name: "card.defaultImage"))
            let titleData = request.title.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(titleData), name: "card.title"))
            let nameData = request.name.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(nameData), name: "card.name"))
            let birthDateData = request.birthDate.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(birthDateData), name: "card.birthDate"))
            let mbtiData = request.mbti.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(mbtiData), name: "card.mbti"))
            let instagramData = request.instagram.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(instagramData), name: "card.instagram"))
            let linkNameData = request.linkName.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(linkNameData), name: "card.linkName"))
            let linkData = request.link.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(linkData), name: "card.link"))
            let descriptionData = request.description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(descriptionData), name: "card.description"))
            let isMinchoData = Bool(request.isMincho).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isMinchoData), name: "card.isMincho"))
            let isSojuData = Bool(request.isSoju).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isSojuData), name: "card.isSoju"))
            let isBoomukData = Bool(request.isBoomuk).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isBoomukData), name: "card.isBoomuk"))
            let isSaucedData = Bool(request.isSauced).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isSaucedData), name: "card.isSauced"))
            let oneQuestionData = request.oneQuestion.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(oneQuestionData), name: "card.oneQuestion"))
            let oneAnswerData = request.oneAnswer.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(oneAnswerData), name: "card.oneAnswer"))
            let twoQuestionData = request.twoQuestion.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(twoQuestionData), name: "card.twoQuestion"))
            let twoAnswerData = request.twoAnswer.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(twoAnswerData), name: "card.twoAnswer"))
            
            let imageData = MultipartFormData(provider: .data(image.pngData() ?? Data()), name: "image", fileName: "image", mimeType: "image/png")
            multiPartData.append(imageData)
            
            return .uploadMultipart(multiPartData)
        case .cardListFetch(let userID):
            return .requestParameters(parameters: ["userId": userID], encoding: URLEncoding.queryString)
        case .cardListEdit(let requestModel):
            return .requestJSONEncodable(requestModel)
        case .cardDelete:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardDetailFetch:
            return .none
        case .cardCreation:
            return ["Content-Type": "multipart/form-data"]
        case .cardListFetch:
            return ["Content-Type": "application/json"]
        case .cardListEdit:
            return ["Content-Type": "application/json"]
        case .cardDelete:
            return .none
        }
    }
}
