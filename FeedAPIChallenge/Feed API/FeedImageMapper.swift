//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Eugene on 2021-09-09.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal enum NetworkErrorCode {
	static let SUCCESS_200 = 200
	static let REDIRECT_300 = 300
	static let BAD_REQUEST_400 = 400
	static let UNAUTHORIZED_401 = 401
	static let FORBIDDEN_403 = 403
	static let NOT_FOUND = 404
	static let SERVER_500 = 500
}

internal class FeedImageMapper {
	private struct ItemsDTO: Decodable {
		let items: [Item]
	}

	private struct Item: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL

		var imageItem: FeedImage {
			return FeedImage(id: image_id,
			                 description: image_desc,
			                 location: image_loc,
			                 url: image_url)
		}
	}

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == NetworkErrorCode.SUCCESS_200,
		      let itemsDTO = try? JSONDecoder().decode(ItemsDTO.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(itemsDTO.items.map { $0.imageItem })
	}
}
