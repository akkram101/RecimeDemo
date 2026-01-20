//
//  Post.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SmartCodable

struct Post: SmartCodableX {
    var id: String = ""
    var userId: String = ""
    var content: String = ""
    var createdAt: String = ""
    var comments: [Comment]? = nil
    var likes: Int? = nil
}
