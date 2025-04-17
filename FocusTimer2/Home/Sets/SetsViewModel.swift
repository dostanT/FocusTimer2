//
//  SetsViewModel.swift
//  FocusTimer2
//
//  Created by Dostan Turlybek on 10.04.2025.
//


import Foundation

/*
 var totalTime: Int // в часах
 var workPercentage: Int
 var numberOfIterations: Int
 var currentIteration: Int
 var timeRemaining: Int
 var isWorkTime: Bool
 var isRunning: Bool
 
 
 var workTime: Int
 var breakTime: Int
 var numberOfIterations: Int
 var currentIteration: Int
 var timeRemaining: Int
 var isWorkTime: Bool
 var isRunning: Bool
 */

class SetsViewModel: ObservableObject {
    @Published var data: [SetsModel] = [SetsModel(name: "New Set", typeID: 0, type: .percentage(TimerPercentageModel(
        totalTime: 7,
        workPercentage: 70,
        numberOfIterations: 7,
        currentIteration: 0,
        timeRemaining: 0,
        isWorkTime: true,
        isRunning: false)))]
    
    @Published var name: String = ""
    // if 0 -> Percentage else if 1 -> Standart
    @Published var type: Int = 0
    
    @Published var workTime: Int = 25
    @Published var breakTime: Int = 25
    
    @Published var totalTime: Int = 7
    @Published var workPercentage: Int = 70
    
    @Published var numberOfIterations: Int = 7
    
    
    func add(){
        var newData: SetsModel = SetsModel(name: name, typeID: 0)
        
        if type == 0{
            newData.typeID = type
            newData.type = .percentage(TimerPercentageModel(
                totalTime: totalTime,
                workPercentage: workPercentage,
                numberOfIterations: numberOfIterations,
                currentIteration: 0,
                timeRemaining: 0,
                isWorkTime: true,
                isRunning: false))
        }
        else if type == 1{
            newData.typeID = type
            newData.type = .standart(StandartModel(
                workTime: workTime,
                breakTime: breakTime,
                numberOfIterations: numberOfIterations,
                currentIteration: 0,
                timeRemaining: 0,
                isWorkTime: true,
                isRunning: false))
        }
        
        data.append(newData)
        name = ""
        type = 0
        
        workTime = 25
        breakTime = 25
        
        totalTime = 7
        workPercentage = 70
        
        numberOfIterations = 7
    }
    
    func delete(name: String) {
        data.removeAll { $0.name == name }
    }
    
    func update(name: String) {
        if let index = data.firstIndex(where: { $0.name == name }) {
            var updatedSet = data[index]
            updatedSet.name = self.name
            updatedSet.typeID = self.type
            
            if type == 0 {
                updatedSet.type = .percentage(TimerPercentageModel(
                    totalTime: totalTime,
                    workPercentage: workPercentage,
                    numberOfIterations: numberOfIterations,
                    currentIteration: 0,
                    timeRemaining: 0,
                    isWorkTime: true,
                    isRunning: false))
            } else if type == 1 {
                updatedSet.type = .standart(StandartModel(
                    workTime: workTime,
                    breakTime: breakTime,
                    numberOfIterations: numberOfIterations,
                    currentIteration: 0,
                    timeRemaining: 0,
                    isWorkTime: true,
                    isRunning: false))
            }
            
            data[index] = updatedSet
        }
        
        // Reset the form
        
        type = 0
        workTime = 25
        breakTime = 25
        totalTime = 7
        workPercentage = 70
        numberOfIterations = 7
    }
    
    func start(){
        
    }
}
