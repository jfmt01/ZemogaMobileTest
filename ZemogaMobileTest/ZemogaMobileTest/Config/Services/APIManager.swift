//
//  APIManager.swift
//  ZemogaMobileTest
//
//  Created by Fernando  Moreno on 6/02/22.
//


import Foundation
import Combine


class APIManager{
    
    static let shared = APIManager()
    
    //MARK: - API Conection constants
    struct Constants{
        static let mainUrl: String = "https://my-json-server.typicode.com"
        static let endpointRoute: String = "/jfmt01/ZemogaJSONDB/posts"
        static let decoder: JSONDecoder = JSONDecoder()
    }
    
    //MARK: - Function to fetch froma API
    //Implemented with a basic Combine Framework aproachment
    var anyCancellable = Set<AnyCancellable>()
    
    func getApiPostsList() -> AnyPublisher<[Post], Error>{
        
        let fullUrl = URL(string: Constants.mainUrl+Constants.endpointRoute)!
        print(fullUrl)
        return Future{[weak self] promise in
            guard let self = self else{return}
            
            URLSession.shared.dataTaskPublisher(for: fullUrl)
                .retry(1)
                .mapError{$0}
                .tryMap{element -> Data in
                    print(element.data)
                    guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                        throw URLError(.badServerResponse)
                    }
                    
                    return element.data
                }
                .decode(type: [Post].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink{_ in
                    
                }receiveValue: { posts in
                    promise(.success(posts))
                }
                .store(in: &self.anyCancellable)
        }
        .eraseToAnyPublisher()
    }
}





