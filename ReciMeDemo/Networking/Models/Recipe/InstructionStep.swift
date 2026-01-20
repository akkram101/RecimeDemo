//
//  InstructionStepDTO.swift
//  ReciMeDemo
//
//  Created by Akkram Bederi on 1/18/26.
//

import SmartCodable

struct InstructionStep: SmartCodableX, Equatable {
    var stepNumber: Int = 0
    var description: String = ""
    var durationMinutes: Int? = nil
    
    static func == (lhs: InstructionStep, rhs: InstructionStep) -> Bool {
        lhs.stepNumber == rhs.stepNumber
    }
}
