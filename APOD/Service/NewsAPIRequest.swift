//
//  NewsAPIRequest.swift
//  News
//
//  Created by Venkatesh S on 07/03/22.
//

import Foundation

struct APODAPIRequest: DataRequest {
    
    private let apiKey: String = "eSm5Rq3uastC0AqUPTUZmhez6ilrOcMTSXbPKVhC"
    var dateString: String = ""
    var url: String {
        let baseURL: String = "https://api.nasa.gov/planetary/apod?"
        let path: String = ""
        return baseURL + path
    }
    var queryItems: [String : String] {
        [
            "api_key": apiKey,
            "date":"\(dateString)"
        ]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> APODModel {
        let decoder = JSONDecoder()
        let response = try decoder.decode(APODModel.self, from: data)
        return response
    }
}
