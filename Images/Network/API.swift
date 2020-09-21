//
//  API.swift
//  Images
//
//  Created by Nikolay Eckert on 22.09.2020.
//

import UIKit

struct API {
	static func downloadImage(url: String, index: Int, completion: @escaping (Data?, Error?) -> Void) {
		guard var urlComponents = URLComponents(string: url) else {
			completion(nil, ErrorApi.generateURLCompontentFail)
			return
		}
		
		urlComponents.queryItems = [
			URLQueryItem(name: "text", value: index.description),
		]

		guard let url = urlComponents.url else {
			completion(nil, ErrorApi.generateURLCompontentFail)
			return
		}
		
		self.getData(from: url) { data, response, error in
			guard let data = data, error == nil else {
				completion(nil, ErrorApi.downloadFail)
				return
			}
			
			completion(data, nil)
		}
	}
	
	private static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
	}
}

enum ErrorApi: Error {
	case generateURLCompontentFail
	case downloadFail
}
