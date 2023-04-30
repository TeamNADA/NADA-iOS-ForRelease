//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by kimhyungyu on 2023/02/05.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

extension IntentHandler: MyCardIntentHandling {
    func provideMyCardOptionsCollection(for intent: MyCardIntent, with completion: @escaping (INObjectCollection<MyCard>?, Error?) -> Void) {
        if let cardItems {
            let myCards = cardItems.map { card in
                let myCard = MyCard(identifier: card.cardUUID, display: card.cardName)
                
                return myCard
            }
            let collection = INObjectCollection(items: myCards)
            completion(collection, nil)
        }
    }
    
    func defaultMyCard(for intent: MyCardIntent) -> MyCard? {
        var myCard: MyCard?
        if let cardItems {
            myCard = MyCard(identifier: cardItems[0].cardUUID, display: cardItems[0].cardName)
        }
        
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
        urlRequest.addValue("Authorization", forHTTPHeaderField: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEwfQ.rq__Rzvunpxq3paeo2fK4i_oeupyDlHp3q1RW6uSHSQ")
//        print("😀", UserDefaults.appGroup.string(forKey: "accessToken") ?? "")
        
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
                        print("😃", result?.status)
                    } else {
                        completion(.success(result))
                    }
                } else {
                    completion(.failure(WidgetError.decodeFail(status: status)))
                }
            }
        }.resume()
    }
}
