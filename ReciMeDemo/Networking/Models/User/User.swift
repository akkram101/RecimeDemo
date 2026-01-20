//
//  User.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SmartCodable

struct User: SmartCodableX {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var avatarURL: String?
    var createdAt: String?
}
