//
//  MockableTarget.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import Foundation
import Moya

protocol MockableTarget: TargetType {
    /// Optional mock file name (without .json extension)
    var mockFileName: String? { get }
}
