//
//  ErrorResponse.swift
//  News
//
//  Created by Venkatesh S on 07/03/22.
//

import Foundation


enum ErrorResponse: String {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var description: String {
        switch self {
        case .apiError: return "Invalid API - Please check with an administrator"
        case .invalidEndpoint: return "There is something problem with the endpoint"
        case .invalidResponse: return "There is something problem with the response"
        case .noData: return "There is something problem with the data"
        case .serializationError: return "There is something problem with the serialization process"
        }
    }
}
