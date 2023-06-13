//
//  APIManager.swift
//  Filmoteka
//
//  Created by Ірина Зеліско on 10.06.2023.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://itunes.apple.com/search"
    
    func searchMovies(withQuery query: String, completion: @escaping ([MovieCell]?, Error?) -> Void) {
        let parameters = ["term": query, "media": "movie"]
        
        guard let url = createURL(withPath: baseURL, parameters: parameters) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SearchResponse.self, from: data)
                let movies = response.results.map { (movieResult: MovieResult) -> MovieCell in
                    let year = self.extractYear(from: movieResult.releaseDate)
                    return MovieCell(title: movieResult.trackName,
                                     year: year,
                                     genre: movieResult.primaryGenreName,
                                     posterImageView: movieResult.artworkURL,
                                     plot: movieResult.longDescription,
                                     url: movieResult.previewUrl,
                                     trackViewUrl: movieResult.trackViewUrl,
                                     id: movieResult.trackId
                    )
                }
                completion(movies, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    private func createURL(withPath path: String, parameters: [String: String]) -> URL? {
        guard var components = URLComponents(string: path) else {
            return nil
        }
        
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url
    }
    
    private func extractYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return String(year)
        } else {
            return dateString
        }
    }
}



struct SearchResponse: Codable {
    let results: [MovieResult]
}

struct MovieResult: Codable {
    let trackName: String
    let releaseDate: String
    let primaryGenreName: String
    let artworkURL: String
    let longDescription: String
    let artistName: String
    let previewUrl: String
    let trackViewUrl: String
    let trackId: Int
    
    enum CodingKeys: String, CodingKey {
        case trackName
        case releaseDate
        case primaryGenreName
        case artworkURL = "artworkUrl100"
        case longDescription
        case artistName
        case previewUrl
        case trackViewUrl
        case trackId
    }
}


