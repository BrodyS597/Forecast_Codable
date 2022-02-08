//
//  NetworkController.swift
//  Forecast_Codable
//
//  Created by Brody Sears on 2/7/22.
//

import Foundation
// api key: "ddae98f4e48d427f9c59a2ec2c5521c6"
//baseURLString = "https://api.weatherbit.io/v2.0/forecast/daily"

class NetworkController {
    
    // MARK: - URL
    private static let baseURLString = "https://api.weatherbit.io/"
    
    static func fetchDays(completion: @escaping (TopLevelDictionary?) -> Void ) {
        guard let baseURL = URL(string: baseURLString) else { return completion(nil)}
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/v2.0/forecast/daily"
        let apiQuery = URLQueryItem(name: "key", value: "ddae98f4e48d427f9c59a2ec2c5521c6")
        let cityQuery = URLQueryItem(name: "city", value: "Tooele")
        let unitsQuery = URLQueryItem(name: "units", value: "I")
        urlComponents?.queryItems = [apiQuery, cityQuery, unitsQuery]
        
        guard let finalUrl = urlComponents?.url else { return completion(nil)}
        print(finalUrl)
        
        URLSession.shared.dataTask(with: finalUrl) { dayData, _, error in
            if let error = error {
                print("There was an error fetching the data, the url is \(finalUrl) the error is \(error.localizedDescription)")
                completion(nil)
            }
            guard let dayData = dayData else {
                print("There was an error receiving the data")
                completion(nil)
                return
            }
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: dayData)
                completion(topLevelDictionary)
            } catch {
                print("Error in Do/Try/Catch:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}// end of class
