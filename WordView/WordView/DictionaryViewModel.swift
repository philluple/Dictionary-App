//
//  DictionaryViewModel.swift
//  WordView
//
//  Created by Phillip Le on 10/9/23.
//

import Foundation

enum getDef {
    case success(String)
    case error
}
enum getRhyme {
    case success([String])
    case error
}

class DictionaryViewModel: ObservableObject{
    @Published var recent: [String] = []


    let headers = [
        "X-RapidAPI-Key": "8ceb278b2emshe7c6ad44ac75e29p1b3640jsn59e111b1ad73",
        "X-RapidAPI-Host": "wordsapiv1.p.rapidapi.com"
    ]

    func findRhymes(word: String, completion: @escaping (getRhyme) -> Void){
        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)/rhymes")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        var words: [String] = []

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.error) // Notify completion with an error
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = json as? [String: Any] {
                                if let rhymesDictionary = dictionary["rhymes"] as? [String: Any],
                                   let allRhymes = rhymesDictionary["all"] as? [String] {
                                    words = Array(allRhymes.prefix(10)) // Limit to the first 10 words
                                    completion(.success(words))
                                }
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                            completion(.error) // Notify completion with an error
                        }
                    }
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    completion(.error) // Notify completion with an error
                }
            }
        }

        task.resume()
    }

    func getDef(word: String, completion: @escaping (getDef) -> Void) {
        recent.append(word)
        let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)/definitions")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared

        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = json as? [String: Any] {
                                if let definitions = dictionary["definitions"] as? [[String: Any]] {
                                    for definition in definitions {
                                        if let definitionText = definition["definition"] as? String {
                                            completion(.success(definitionText))
//                                            print("Definition: \(definitionText)")
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                } else {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
            }
        }

        task.resume()
    }

    
    
}
