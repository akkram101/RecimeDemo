//
//  Comment.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SmartCodable

struct Comment: SmartCodableX {
    var id: String = ""
    var postId: String = ""
    var userId: String = ""
    var text: String = ""
    var createdAt: String = ""
}
