//
//  File.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

final class MoyaLoggerPlugin: PluginType {
    
  // Request를 보낼 때 호출
  func willSend(_ request: RequestType, target: TargetType) {
    guard let httpRequest = request.request else {
      print("--> 유효하지 않은 요청")
      return
    }
    let url = httpRequest.description
    let method = httpRequest.httpMethod ?? "unknown method"
    var log = "----------------------------------------------------\n[\(method)] \(url)\n----------------------------------------------------\n"
    log.append("API: \(target)\n")
    if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
      log.append("header: \(headers)\n")
    }
    if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
      log.append("\(bodyString)\n")
    }
    log.append("------------------- END \(method) --------------------------")
    print(log)
  }
    
  // Response가 왔을 때
  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    switch result {
    case let .success(response):
      onSuceed(response, target: target, isFromError: false)
    case let .failure(error):
      onFail(error, target: target)
    }
  }
    
  func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
    let request = response.request
    let url = request?.url?.absoluteString ?? "nil"
    let statusCode = response.statusCode
    var log = "------------------- 네트워크 통신 성공(isFromError: \(isFromError)) -------------------"
      switch statusCode {
      case 401:
          log.append("메롱 401이지롱")
          userTokenReissueWithAPI(request: UserTokenReissueRequset(accessToken: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) ?? "",
                                                                   refreshToken: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.refreshToken) ?? ""))
      default:
          log.append("메롱 \(statusCode)이지롱")
      print(log)
      
//    log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
//    log.append("API: \(target)\n")
//    response.response?.allHeaderFields.forEach {
//      log.append("\($0): \($1)\n")
//    }
//    if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
//      log.append("\(reString)\n")
//    }
//    log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
//    print(log)
      }
  }
    
  func onFail(_ error: MoyaError, target: TargetType) {
    if let response = error.response {
      onSuceed(response, target: target, isFromError: true)
      return
    }
    var log = "네트워크 오류"
    log.append("<-- \(error.errorCode) \(target)\n")
    log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
    log.append("<-- END HTTP")
    print(log)
  }
}

extension MoyaLoggerPlugin {
    func userTokenReissueWithAPI(request: UserTokenReissueRequset) {
        UserAPI.shared.userTokenReissue(request: request) { response in
            switch response {
            case .success(let loginData):
//                print("userTokenReissueWithAPI - success")
//                if let userData = loginData as? UserWithTokenRequest {
//                    UserDefaults.standard.set(userData.user.userID, forKey: Const.UserDefaultsKey.userID)
//                    UserDefaults.standard.set(userData.user.token.accessToken, forKey: Const.UserDefaultsKey.accessToken)
//                    UserDefaults.standard.set(userData.user.token.refreshToken, forKey: Const.UserDefaultsKey.refreshToken)
                print("asdfasd", loginData)
            case .requestErr(let message):
                print("userTokenReissueWithAPI - requestErr: \(message)")
                if message as? String == "리프레시 토큰이 만료되었습니다." {
                    print("유저 디폴트 삭제")
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.accessToken)
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.refreshToken)
                }
            case .pathErr:
                print("userTokenReissueWithAPI - pathErr")
            case .serverErr:
                print("userTokenReissueWithAPI - serverErr")
            case .networkFail:
                print("userTokenReissueWithAPI - networkFail")
            }
        }
    }
}
