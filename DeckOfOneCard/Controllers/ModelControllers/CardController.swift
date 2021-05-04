//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Jaymond Richardson on 5/4/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    static func fetchCard(completion: @escaping (Result<Card, CardError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let countQuery = URLQueryItem(name: "count", value: "1")
        components?.queryItems = [countQuery]
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print("finalURL\(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else {return completion(.failure(.noData))}
                return completion(.success(card))
            }catch{
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
        
        let url = card.image
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            return completion(.success(image))
        }.resume()
    }
    
    
    
    
    
}
