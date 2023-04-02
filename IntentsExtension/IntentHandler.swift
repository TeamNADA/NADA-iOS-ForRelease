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
        // TODO: - 서버 통신 혹은 DB 에서 선택 목록 가져온다.
        let myCards: [MyCard] = Card.mockData.map { card in
            let myCard = MyCard(identifier: card.cardUUID, display: card.cardName)
            
            return myCard
        }
        let collection = INObjectCollection(items: myCards)
        
        completion(collection, nil)
    }
    
    func defaultMyCard(for intent: MyCardIntent) -> MyCard? {
        // TODO: - 내 명함이 존재하면 첫 번째 명함을 기본값으로 설정. 존재하지 않다면 nil 반환.
        let myCard = MyCard(identifier: Card.mockData[0].cardUUID,
                            display: Card.mockData[0].cardName)
        
        return myCard
    }
}
