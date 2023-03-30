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
    case cardListFetch(userID: String, isList: Bool, offset: Int?)
    case cardListEdit(request: CardListEditRequest)
    case cardDelete(cardID: String)
    case imageUpload(image: UIImage)
    case tasteFetch(cardType: CardType)
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
        case .imageUpload:
            return "/image"
        case .tasteFetch(let cardType):
            return "/card/\(cardType)/taste"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardDetailFetch, .cardListFetch, .tasteFetch:
            return .get
        case .cardCreation, .imageUpload:
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
        case .cardDetailFetch, .cardDelete, .tasteFetch:
            return .requestPlain
        case .cardCreation(let request, let image):
            
            var multiPartData: [Moya.MultipartFormData] = []
            
            let userIDData = request.userID.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(userIDData), name: "card.userId"))
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
            let instagramIDData = request.frontCard.instagramID.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(instagramIDData), name: "card.instagram"))
            let linkURLData = request.frontCard.linkURL.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(linkURLData), name: "card.link"))
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
            let oneTMI = request.backCard.oneTMI.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(oneTMI), name: "card.oneTmi"))
            let twoTMI = request.backCard.twoTMI.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(twoTMI), name: "card.twoTmi"))
            let threeTMI = request.backCard.threeTMI.data(using: .utf8) ?? Data()
            multiPartData.append(MultipartFormData(provider: .data(threeTMI), name: "card.threeTmi"))
            
            let imageData = MultipartFormData(provider: .data(image.pngData() ?? Data()), name: "image", fileName: "image", mimeType: "image/png")
            multiPartData.append(imageData)
            
            return .uploadMultipart(multiPartData)
        case .cardListFetch(let userID, let isList, let offset):
            return .requestParameters(parameters: ["userId": userID,
                                                   "list": isList,
                                                   "offset": offset ?? ""],
                                      encoding: URLEncoding.queryString)
        case .cardListEdit(let requestModel):
            return .requestJSONEncodable(requestModel)
        case .imageUpload(let image):
            var multiPartData: [Moya.MultipartFormData] = []
            let imageData = MultipartFormData(provider: .data(image.pngData() ?? Data()), name: "image", mimeType: "image/png")
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardDetailFetch, .cardListFetch, .cardDelete, .tasteFetch:
            return Const.Header.bearerHeader()
        case .cardListEdit:
            return Const.Header.basicHeader()
        case .cardCreation, .imageUpload:
            return Const.Header.multipartFormHeader()
        }
    }
}
