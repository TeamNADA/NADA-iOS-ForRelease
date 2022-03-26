//
//  File.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation
import Moya

final class MoyaLoggerPlugin: PluginType {
    
//    private let viewController: UIViewController
    
//    init(viewController: UIViewController) {
//        self.viewController = viewController
//    }

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
        log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("API: \(target)\n")
        response.response?.allHeaderFields.forEach {
            log.append("\($0): \($1)\n")
        }
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("\(reString)\n")
        }
        log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
        print(log)
        
        switch statusCode {
        case 401:
            let acessToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken)
            let refreshToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.refreshToken)
            userTokenReissueWithAPI(request: UserReissueToken(accessToken: acessToken ?? "",
                                                              refreshToken: refreshToken ?? ""))
        default:
            return
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
    func userTokenReissueWithAPI(request: UserReissueToken) {
        UserAPI.shared.userTokenReissue(request: request) { response in
            switch response {
            case .success(let data):
                if let tokenData = data as? UserReissueToken {
                    UserDefaults.standard.set(tokenData.accessToken, forKey: Const.UserDefaultsKey.accessToken)
                    UserDefaults.standard.set(tokenData.refreshToken, forKey: Const.UserDefaultsKey.refreshToken)
                    
                    print("userTokenReissueWithAPI - success")
                }
            case .requestErr(let statusCode):
                // FIXME: - 예원이가 상태코드 정해주면 변경
                if let statusCode = statusCode as? Int, statusCode == 402 {
                    print("유저 디폴트 삭제")
                    print("로그인 뷰로 보내기")
                    
                    // root view controller 를 바꾸자
                    let loginVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.loginViewController)
                    UIApplication.shared.windows.first {$0.isKeyWindow}?.rootViewController = loginVC
                    
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.accessToken)
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.refreshToken)
                    UserDefaults.standard.removeObject(forKey: Const.UserDefaultsKey.userID)
                }
                print("userTokenReissueWithAPI - requestErr: \(statusCode)")
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
