//
//  AuthResponse.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SmartCodable

struct AuthResponse: SmartCodableX {
    var token: String = ""
    var refreshToken: String? = nil
    var user: User? = nil
}
