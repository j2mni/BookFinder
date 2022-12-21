//
//  book.swift
//  BookFinderWithCodableEx
//
//  Created by j2mni on 2022/10/24.
//

import Foundation


struct Meta: Codable {
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}

struct Book: Codable {
    let authors: [String]
    let contents: String
    let datetime: String
    let isbn: String
    let price: Int
    let publisher: String
    let sale_price: Int
    let status: String
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String
}

struct ResultData: Codable {
    let meta: Meta
    let documents: [Book]
}
