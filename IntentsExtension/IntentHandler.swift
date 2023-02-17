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
        let myCards: [MyCard] = Card.mockData.map { card in
            let myCard = MyCard(identifier: card.cardID, display: card.title)
            
            return myCard
        }
        let collection = INObjectCollection(items: myCards)
        
        completion(collection, nil)
    }
    
    func defaultMyCard(for intent: MyCardIntent) -> MyCard? {
        let myCard = MyCard(identifier: Card.mockData[0].cardID,
                            display: Card.mockData[0].title)
        
        return myCard
    }
}
