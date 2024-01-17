//
//  Product.swift
//  CCommerce
//
//  Created by 이정동 on 1/17/24.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
    let discount: String
    let originalPrice: Int
    let discountPrice: Int
}
