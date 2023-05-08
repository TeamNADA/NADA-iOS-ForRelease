//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by kimhyungyu on 2023/02/05.
//

import Intents

class IntentHandler: INExtension {
    
    // MARK: - Properties
    
    var cardItems: [Card]?
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

extension IntentHandler: MyCardIntentHandling {
    // 내 명함 목록 선택할 때 호출.
    func provideMyCardOptionsCollection(for intent: MyCardIntent, with completion: @escaping (INObjectCollection<MyCard>?, Error?) -> Void) {
        cardListFetchWithAPI { result in
            switch result {
            case .success(let result):
                if let cardItems = result?.data {
                    let myCards = cardItems.map { card in
                        let myCard = MyCard(identifier: card.cardUUID, display: card.cardName)
                        myCard.userName = card.userName
                        myCard.cardImage = card.cardImage
                        
                        return myCard
                    }
                    let collection = INObjectCollection(items: myCards)
                    completion(collection, nil)
                }
            case .failure(let err):
                print(err)
                completion(nil, nil)
            }
        }
    }
    
    // 위젯 추가할때 호출. 기본값 설정.
    func defaultMyCard(for intent: MyCardIntent) -> MyCard? {
        var myCard: MyCard?
        
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) { [weak self] in
            group.enter()
            
            self?.cardListFetchWithAPI { [weak self] result in
                switch result {
                case .success(let result):
                    if let result {
                        self?.cardItems = result.data
                        myCard = MyCard(identifier: self?.cardItems?[0].cardUUID ?? "", display: self?.cardItems?[0].cardName ?? "")
                        myCard?.userName = self?.cardItems?[0].userName
                        myCard?.cardImage = self?.cardItems?[0].cardImage
                    }
                case .failure(let err):
                    print(err)
                }
                group.leave()
            }
        }
        
        _ = group.wait(timeout: .now() + 60)
        
        return myCard
    }
}

// MARK: - Newtwork

enum WidgetError: Error {
    case networkFail(status: Int, code: String, message: String)
    case decodeFail(status: Int)
    case error(status: Int, error: Error)
}

extension IntentHandler {
    func cardListFetchWithAPI(completion: @escaping (Result<GenericResponse<[Card]>?, Error>) -> Void) {
        guard let url = URL(string: "http://3.35.107.3:8080/api/v1/card") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(UserDefaults.appGroup.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
        print("😀", UserDefaults.appGroup.string(forKey: "accessToken") ?? "")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let status = (response as? HTTPURLResponse)?.statusCode else { return }
            
            if let error = error {
                completion(.failure(WidgetError.error(status: status, error: error)))
            } else {
                if let data {
                    let result = try? JSONDecoder().decode(GenericResponse<[Card]>.self, from: data)
                    
                    if status != 200 {
                        completion(.failure(WidgetError.networkFail(status: status,
                                                                    code: result?.code ?? "none code",
                                                                    message: result?.message ?? "none message")))
                    } else {
                        if let result {
                            if result.status != 200 {
                                completion(.failure(WidgetError.networkFail(status: status,
                                                                            code: result.code ?? "none code",
                                                                            message: result.message ?? "none message")))
                            } else {
                                completion(.success(result))
                            }
                        } else {
                            completion(.failure(WidgetError.decodeFail(status: status)))
                        }
                    }
                }
            }
        }.resume()
    }
}
