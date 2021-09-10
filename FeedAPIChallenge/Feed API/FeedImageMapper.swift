//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Eugene on 2021-09-09.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

private enum HTTPResponseStatusCode {
	static let success200 = 200
}

class FeedImageMapper {
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

	static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == HTTPResponseStatusCode.success200,
		      let itemsDTO = try? JSONDecoder().decode(ItemsDTO.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(itemsDTO.items.map(\.imageItem))
	}
}
