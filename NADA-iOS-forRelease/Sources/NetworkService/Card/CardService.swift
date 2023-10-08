//
//  CardService.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

enum CardService {
    case cardDetailFetch(cardUUID: String)
    case cardCreation(request: CardCreationRequest, type: CreationType, cardUUID: String? = nil)
    case cardListPageFetch(pageNumber: Int, pageSize: Int)
    case cardListFetch
    case cardReorder(request: [CardReorderInfo])
    case cardDelete(cardID: Int)
    case imageUpload(image: UIImage)
    case tasteFetch(cardType: CardType)
}

extension CardService: TargetType {
    
    var baseURL: URL {
        return URL(string: Const.URL.baseURL)!
    }
    
    var path: String {
        switch self {
        case .cardDetailFetch(let cardUUID):
            return "/v1/card/\(cardUUID)/search"
        case .cardCreation:
            return "/v1/card"
        case .cardListPageFetch:
            return "/v1/card/page"
        case .cardListFetch:
            return "/v1/card"
        case .cardReorder:
            return "/v1/card/reorder"
        case .cardDelete(let cardID):
            return "/v1/card/\(cardID)"
        case .imageUpload:
            return "/v1/image"
        case .tasteFetch(let cardType):
            return "/card/v2/\(cardType.rawValue)/taste"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cardDetailFetch, .cardListPageFetch, .cardListFetch, .tasteFetch:
            return .get
        case .cardCreation(_, let creationType, _):
            switch creationType {
            case .create:
                return .post
            case .modify:
                return .put
            }
        case .cardReorder, .imageUpload:
            return .post
        case .cardDelete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .cardDetailFetch, .cardDelete, .tasteFetch, .cardListFetch:
            return .requestPlain
        case .cardCreation(let request, let creationType, let cardUUID):
            var parameters: [String: Any] = ["birth": request.frontCard.birth,
                                             "cardImage": request.cardImageURL,
                                             "cardName": request.frontCard.cardName,
                                             "cardTastes": request.backCard.tastes,
                                             "cardType": request.cardType,
                                             "userName": request.frontCard.userName]
            
            if let departmentName = request.frontCard.departmentName {
                parameters["departmentName"] = departmentName
            }
            
            if let mailAddress = request.frontCard.mailAddress {
                parameters["mailAddress"] = mailAddress
            }
            
            if let mbti = request.frontCard.mbti {
                parameters["mbti"] = mbti
            }
            
            if let phoneNumber = request.frontCard.phoneNumber {
                parameters["phoneNumber"] = phoneNumber
            }
            
            if let instagram = request.frontCard.instagram {
                parameters["instagram"] = instagram
            }
            
            if let twitter = request.frontCard.twitter {
                parameters["twitter"] = twitter
            }
            
            if let tmi = request.backCard.tmi {
                parameters["tmi"] = tmi
            }
            
            if let urls = request.frontCard.urls {
                parameters["urls"] = urls
            }
            
            if creationType == .modify, let cardUUID {
                parameters["cardUuid"] = cardUUID
            }
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .cardListPageFetch(let pageNumber, let pageSize):
            return .requestParameters(parameters: ["pageNo": pageNumber,
                                                   "pageSize": pageSize],
                                      encoding: URLEncoding.queryString)
        case .cardReorder(let request):
            let requestModel = CardReorderInfosRequest(cardReorderInfos: request)
            
            return .requestJSONEncodable(requestModel)
        case .imageUpload(let image):
            var multiPartData: [Moya.MultipartFormData] = []
            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 0.5) ?? Data()), name: "image", fileName: "image", mimeType: "image/png")
            multiPartData.append(imageData)
            
            return .uploadMultipart(multiPartData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .cardDetailFetch, .cardListPageFetch, .cardListFetch, .cardDelete, .tasteFetch:
            return Const.Header.bearerHeader()
        case .cardReorder, .cardCreation:
            return Const.Header.basicHeader()
        case .imageUpload:
            return Const.Header.multipartFormHeader()
        }
    }
}
