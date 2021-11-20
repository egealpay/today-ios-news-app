//
//  NewsData.swift
//  Today
//
//  Created by Ege Alpay on 20.11.2021.
//

import Foundation

struct NewsData: Codable {
    let pagination: Pagination
    let data: [News]
}

struct Pagination: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let total: Int
}

struct News: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let source: String?
    let image: String?
    let category: String?
    let language: String?
    let country: String?
    let published_at: String?
}
