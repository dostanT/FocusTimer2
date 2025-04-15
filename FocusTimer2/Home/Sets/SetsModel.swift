//
//  SetsModel.swift
//  FocusTimer2
//
//  Created by Dostan Turlybek on 10.04.2025.
//

import Foundation



enum SetsType{
    case percentage(TimerPercentageModel)
    case standart(StandartModel)
}

struct SetsModel: Identifiable{
    let id = UUID().uuidString
    var name: String
    var type: SetsType = .percentage(TimerPercentageModel(
        totalTime: 1,
        workPercentage: 80,
        numberOfIterations: 1,
        currentIteration: 0,
        timeRemaining: 0,
        isWorkTime: true,
        isRunning: false))
}



