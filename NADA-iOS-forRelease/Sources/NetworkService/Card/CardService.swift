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
        case .cardDetailFetch, .cardListFetch:
            return .get
        case .cardCreation:
            return .post
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
        case .cardDetailFetch, .cardDelete:
            return .requestPlain
        case .cardCreation(let request, let image):
            
            var multiPartData: [Moya.MultipartFormData] = []
            
            let userIDData = request.userID.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(userIDData), name: "card.userId"))
//            let defaultImageData = "\(request.defaultImage)".data(using: .utf8) ?? Data()
            let defaultImageData = Int(request.frontCard.defaultImage).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(defaultImageData), name: "card.defaultImage"))
            let titleData = request.frontCard.title.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(titleData), name: "card.title"))
            let nameData = request.frontCard.name.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(nameData), name: "card.name"))
            let birthDateData = request.frontCard.birthDate.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(birthDateData), name: "card.birthDate"))
            let mbtiData = request.frontCard.mbti.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(mbtiData), name: "card.mbti"))
            let instagramData = request.frontCard.instagram.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(instagramData), name: "card.instagram"))
            let linkNameData = request.frontCard.linkName.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(linkNameData), name: "card.linkName"))
            let linkData = request.frontCard.link.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(linkData), name: "card.link"))
            let descriptionData = request.frontCard.description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(descriptionData), name: "card.description"))
            let isMinchoData = Bool(request.backCard.isMincho).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isMinchoData), name: "card.isMincho"))
            let isSojuData = Bool(request.backCard.isSoju).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isSojuData), name: "card.isSoju"))
            let isBoomukData = Bool(request.backCard.isBoomuk).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isBoomukData), name: "card.isBoomuk"))
            let isSaucedData = Bool(request.backCard.isSauced).description.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(isSaucedData), name: "card.isSauced"))
            let oneQuestionData = request.backCard.oneQuestion.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(oneQuestionData), name: "card.oneQuestion"))
            let oneAnswerData = request.backCard.oneAnswer.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(oneAnswerData), name: "card.oneAnswer"))
            let twoQuestionData = request.backCard.twoQuestion.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(twoQuestionData), name: "card.twoQuestion"))
            let twoAnswerData = request.backCard.twoAnswer.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(twoAnswerData), name: "card.twoAnswer"))
            
            let imageData = MultipartFormData(provider: .data(image.pngData() ?? Data()), name: "image", fileName: "image", mimeType: "image/png")
            multiPartData.append(imageData)
            
            return .uploadMultipart(multiPartData)
        case .cardListFetch(let userID, let isList, let offset):
            return .requestParameters(parameters: ["userId": userID,
                                                   "list": isList ?? false,
                                                   "offset": offset ?? ""
            ], encoding: URLEncoding.queryString)
        case .cardListEdit(let requestModel):
            return .requestJSONEncodable(requestModel)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardDetailFetch, .cardListFetch, .cardDelete:
            return .none
        case .cardCreation:
            return ["Content-Type": "multipart/form-data"]
        case .cardListEdit:
            return ["Content-Type": "application/json"]
        }
    }
}
