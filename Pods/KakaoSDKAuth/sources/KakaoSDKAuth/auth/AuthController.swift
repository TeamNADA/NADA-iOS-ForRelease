//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit
import SafariServices
import AuthenticationServices
import KakaoSDKCommon

let authController = AuthController.shared

/// 인가 코드 요청 시 추가 상호작용을 요청하고자 할 때 전달하는 파라미터입니다.
public enum Prompt : String {
    
    /// 기본 웹 브라우저에 카카오계정 쿠키(cookie)가 이미 있더라도 이를 무시하고 무조건 카카오계정 로그인 화면을 보여주도록 합니다.
    case Login = "login"
}

public class AuthController {
    
    // MARK: Fields
    
    /// 간편하게 API를 호출할 수 있도록 제공되는 공용 싱글톤 객체입니다.
    public static let shared = AuthController()
    
    //TODO: parameter 방식으로 바꾸기.
    @available(iOS 13.0, *)
    public lazy var presentationContextProvider: Any? = DefaultPresentationContextProvider()
    
    public var authenticationSession : Any?
    
    public var authorizeWithTalkCompletionHandler : ((URL) -> Void)?

    static public func isValidRedirectUri(_ redirectUri:URL) -> Bool {
        return redirectUri.absoluteString.hasPrefix(KakaoSDKCommon.shared.redirectUri())
    }
    
    //PKCE Spec
    public var codeVerifier : String?
    
    public init() {
        resetCodeVerifier()
    }
    
    public func resetCodeVerifier() {
        self.codeVerifier = nil
    }
    
    // MARK: Login with KakaoTalk
    /// :nodoc:
    public func authorizeWithTalk(channelPublicIds: [String]? = nil,
                                  serviceTerms: [String]? = nil,
                                  completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        authController.authorizeWithTalkCompletionHandler = { (callbackUrl) in
            let parseResult = callbackUrl.oauthResult()
            if let code = parseResult.code {
                AuthApi.shared.token(code: code, codeVerifier: self.codeVerifier) { (token, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    else {
                        if let token = token {
                            completion(token, nil)
                            return
                        }
                    }
                }
            }
            else {
                let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                SdkLog.e("Failed to parse redirect URI.")
                completion(nil, error)
                return
            }
        }
        
        let parameters = self.makeParametersForTalk(channelPublicIds: channelPublicIds, serviceTerms: serviceTerms)

        guard let url = SdkUtils.makeUrlWithParameters(Urls.compose(.TalkAuth, path:Paths.authTalk), parameters: parameters) else {
            SdkLog.e("Bad Parameter.")
            completion(nil, SdkError(reason: .BadParameter))
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { (result) in
            if (result) {
                SdkLog.d("카카오톡 실행: \(url.absoluteString)")
            }
            else {
                SdkLog.e("카카오톡 실행 취소")
                completion(nil, SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."))
                return
            }
        }
    }
    
    /// **카카오톡 간편로그인** 등 외부로부터 리다이렉트 된 코드요청 결과를 처리합니다.
    /// AppDelegate의 openURL 메소드 내에 다음과 같이 구현해야 합니다.
    ///
    /// ```
    /// func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ///     if (AuthController.isKakaoTalkLoginUrl(url)) {
    ///         if AuthController.handleOpenUrl(url: url, options: options) {
    ///             return true
    ///         }
    ///     }
    ///     // 서비스의 나머지 URL 핸들링 처리
    /// }
    /// ```
    public static func handleOpenUrl(url:URL,  options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthController.isValidRedirectUri(url)) {
            if let authorizeWithTalkCompletionHandler = authController.authorizeWithTalkCompletionHandler {
                authorizeWithTalkCompletionHandler(url)
            }
        }
        return false
    }
    
    // MARK: Login with Web Cookie

    ///:nodoc: 카카오 계정 페이지에서 로그인을 하기 위한 지원스펙 입니다.
    public func authorizeWithAuthenticationSession(accountParameters: [String:String]? = nil  ,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        return self.authorizeWithAuthenticationSession(agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds:nil,
                                                       serviceTerms:nil,
                                                       accountParameters: accountParameters,
                                                       completion: completion )
    }    
    
    /// :nodoc: iOS 11 이상에서 제공되는 (SF/ASWeb)AuthenticationSession 을 이용하여 로그인 페이지를 띄우고 쿠키 기반 로그인을 수행합니다. 이미 사파리에에서 로그인하여 카카오계정의 쿠키가 있다면 이를 활용하여 ID/PW 입력 없이 간편하게 로그인할 수 있습니다.
    public func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        return self.authorizeWithAuthenticationSession(prompts: prompts,
                                                       agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: nil,
                                                       serviceTerms:nil,
                                                       completion: completion )
    }
    
    /// :nodoc: 카카오싱크 전용입니다. 자세한 내용은 카카오싱크 전용 개발가이드를 참고하시기 바랍니다.
    public func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                                   channelPublicIds: [String]? = nil,
                                                   serviceTerms: [String]? = nil,
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        return self.authorizeWithAuthenticationSession(prompts: prompts,
                                                       agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: channelPublicIds,
                                                       serviceTerms:serviceTerms,
                                                       completion: completion)
    }
    
    /// :nodoc:
    public func authorizeWithAuthenticationSession(scopes:[String],
                                                   completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        AuthApi.shared.agt { [weak self] (agtToken, error) in
            guard let strongSelf = self else {
                completion(nil, SdkError()) //내부에러
                return
            }
            
            if let error = error {
                completion(nil, error)
                return
            }
            else {
                strongSelf.authorizeWithAuthenticationSession(agtToken: agtToken, scopes: scopes) { (oauthToken, error) in
                    completion(oauthToken, error)
                }
            }
        }
    }
    
    /// :nodoc:
    func authorizeWithAuthenticationSession(prompts: [Prompt]? = nil,
                                            agtToken: String? = nil,
                                            scopes:[String]? = nil,
                                            channelPublicIds: [String]? = nil,
                                            serviceTerms: [String]? = nil,
                                            accountParameters: [String:String]? = nil,
                                            completion: @escaping (OAuthToken?, Error?) -> Void) {
        
        let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
            (callbackUrl:URL?, error:Error?) in
            
            guard let callbackUrl = callbackUrl else {
                if #available(iOS 12.0, *), let error = error as? ASWebAuthenticationSessionError {
                    if error.code == ASWebAuthenticationSessionError.canceledLogin {
                        SdkLog.e("The authentication session has been canceled by user.")
                        completion(nil, SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        return
                    } else {
                        SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                        completion(nil, SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        return
                    }
                } else if let error = error as? SFAuthenticationError, error.code == SFAuthenticationError.canceledLogin {
                    SdkLog.e("The authentication session has been canceled by user.")
                    completion(nil, SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                    return
                } else {
                    SdkLog.e("An unknown authentication session error occurred.")
                    completion(nil, SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    return
                }
            }
            
            SdkLog.d("callback url: \(callbackUrl)")
            
            let parseResult = callbackUrl.oauthResult()
            if let code = parseResult.code {
                SdkLog.i("code:\n \(String(describing: code))\n\n" )
                
                AuthApi.shared.token(code: code, codeVerifier: self.codeVerifier) { (token, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    else {
                        if let token = token {
                            completion(token, nil)
                            return
                        }
                    }
                }
            }
            else {
                let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                SdkLog.e("redirect URI error: \(error)")
                completion(nil, error)
                return
            }
        }
        
        var parameters = self.makeParameters(prompts: prompts,
                                             agtToken: agtToken,
                                             scopes: scopes,
                                             channelPublicIds: channelPublicIds,
                                             serviceTerms: serviceTerms)
        
        var url: URL? = nil
        if let accountParameters = accountParameters, !accountParameters.isEmpty {
            for (key, value) in accountParameters {
                parameters[key] = value
            }
            url = SdkUtils.makeUrlWithParameters(Urls.compose(.Auth, path:Paths.kakaoAccountsLogin), parameters:parameters)
        }
        else {
            url = SdkUtils.makeUrlWithParameters(Urls.compose(.Kauth, path:Paths.authAuthorize), parameters:parameters)
        }
        
        if let url = url {
            SdkLog.d("\n===================================================================================================")
            SdkLog.d("request: \n url:\(url)\n parameters: \(parameters) \n")
            
            if #available(iOS 12.0, *) {
                let authenticationSession = ASWebAuthenticationSession(url: url,
                                                                       callbackURLScheme: (try! KakaoSDKCommon.shared.scheme()),
                                                                       completionHandler:authenticationSessionCompletionHandler)
                if #available(iOS 13.0, *) {
                    authenticationSession.presentationContextProvider = authController.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                    if agtToken != nil {
                        authenticationSession.prefersEphemeralWebBrowserSession = true
                    }
                }
                authenticationSession.start()
                authController.authenticationSession = authenticationSession
            }
            else {
                authController.authenticationSession = SFAuthenticationSession(url: url,
                                                                               callbackURLScheme: (try! KakaoSDKCommon.shared.scheme()),
                                                                               completionHandler:authenticationSessionCompletionHandler)
                (authController.authenticationSession as? SFAuthenticationSession)?.start()
            }
        }
    }
}

extension AuthController {
    //Rx 공통 Helper
    
    /// :nodoc:
    public func makeParametersForTalk(channelPublicIds: [String]? = nil,
                                      serviceTerms: [String]? = nil)  -> [String:Any] {
        self.resetCodeVerifier()
        
        var parameters = [String:Any]()
        parameters["client_id"] = try! KakaoSDKCommon.shared.appKey()
        parameters["redirect_uri"] = KakaoSDKCommon.shared.redirectUri()
        parameters["response_type"] = Constants.responseType
        parameters["headers"] = ["KA": Constants.kaHeader].toJsonString()
        
        var extraParameters = [String: Any]()
        if let channelPublicIds = channelPublicIds?.joined(separator: ",") {
            extraParameters["channel_public_id"] = channelPublicIds
        }
        if let serviceTerms = serviceTerms?.joined(separator: ",")  {
            extraParameters["service_terms"] = serviceTerms
        }
        if let approvalType = KakaoSDKCommon.shared.approvalType().type {
            extraParameters["approval_type"] = approvalType
        }
        
        self.codeVerifier = SdkCrypto.shared.generateCodeVerifier()
        
        if let codeVerifier = self.codeVerifier {
            SdkLog.d("code_verifier: \(codeVerifier)")
            if let codeChallenge = SdkCrypto.shared.sha256(string:codeVerifier) {
                extraParameters["code_challenge"] = SdkCrypto.shared.base64url(data:codeChallenge)
                SdkLog.d("code_challenge: \(SdkCrypto.shared.base64url(data:codeChallenge))")
                extraParameters["code_challenge_method"] = "S256"
            }
        }
        
        if !extraParameters.isEmpty {
            parameters["params"] = extraParameters.toJsonString()
        }
        
        return parameters
    }
    
    
    public func makeParameters(prompts : [Prompt]? = nil,
                               agtToken: String? = nil,
                               scopes:[String]? = nil,
                               channelPublicIds: [String]? = nil,
                               serviceTerms: [String]? = nil) -> [String:Any]
    {
        self.resetCodeVerifier()
        
        var parameters = [String:Any]()
        parameters["client_id"] = try! KakaoSDKCommon.shared.appKey()
        parameters["redirect_uri"] = KakaoSDKCommon.shared.redirectUri()
        parameters["response_type"] = Constants.responseType
        parameters["ka"] = Constants.kaHeader
        
        if let approvalType = KakaoSDKCommon.shared.approvalType().type {
            parameters["approval_type"] = approvalType
        }
        
        if let agt = agtToken {
            parameters["agt"] = agt
            
            if let scopes = scopes {
                parameters["scope"] = scopes.joined(separator:" ")
            }
        }
        
        if let prompts = prompts {
            let promptsValues : [String]? = prompts.map { $0.rawValue }
            if let prompt = promptsValues?.joined(separator: ",") {
                parameters["prompt"] = prompt
            }
        }
        
        if let channelPublicIds = channelPublicIds?.joined(separator: ",") {
            parameters["channel_public_id"] = channelPublicIds
        }
        
        if let serviceTerms = serviceTerms?.joined(separator: ",")  {
            parameters["service_terms"] = serviceTerms
        }
        
        self.codeVerifier = SdkCrypto.shared.generateCodeVerifier()
        if let codeVerifier = self.codeVerifier {
            SdkLog.d("code_verifier: \(codeVerifier)")
            if let codeChallenge = SdkCrypto.shared.sha256(string:codeVerifier) {
                parameters["code_challenge"] = SdkCrypto.shared.base64url(data:codeChallenge)
                SdkLog.d("code_challenge: \(SdkCrypto.shared.base64url(data:codeChallenge))")
                parameters["code_challenge_method"] = "S256"
            }
        }
        
        return parameters
    }
}



extension URL {
    // SDK에서 state 제공 계획은 없지만 OAuth 표준이므로 파싱해둔다.
    public func oauthResult() -> (code: String?, error: Error?, state: String?) {
        var parameters = [String: String]()
        if let queryItems = URLComponents(string: self.absoluteString)?.queryItems {
            for item in queryItems {
                parameters[item.name] = item.value
            }
        }
        
        let state = parameters["state"]
        if let code = parameters["code"] {
            return (code, nil, state)
        } else {
            if parameters["error"] == nil {
                parameters["error"] = "unknown"
                parameters["error_description"] = "Invalid authorization redirect URI."
            }
            if parameters["error"] == "cancelled" {
                // 간편로그인 취소버튼 예외처리
                return (nil, SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."), state)
            } else {
                return (nil, SdkError(parameters: parameters), state)
            }
        }
    }
}

@available(iOS 13.0, *)
class DefaultPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
}
