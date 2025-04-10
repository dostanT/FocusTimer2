import Foundation

struct TimerPercentageModel {
    var totalTime: Int // в часах
    var workPercentage: Int
    var numberOfIterations: Int
    var currentIteration: Int
    var timeRemaining: Int
    var isWorkTime: Bool
    var isRunning: Bool
    
    var oneIterationWorkTime: Int {
        (totalTime * 3600) * workPercentage / 100 / numberOfIterations
    }
    
    var oneIterationRestTime: Int {
        (totalTime * 3600) / numberOfIterations - oneIterationWorkTime
    }
    
    var progress: Double {
        if isWorkTime {
            return Double(timeRemaining) / Double(oneIterationWorkTime)
        } else {
            return Double(timeRemaining) / Double(oneIterationRestTime)
        }
    }
    
    var formattedTime: String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    mutating func reset() {
        currentIteration = 0
        isWorkTime = true
        timeRemaining = oneIterationWorkTime
        isRunning = false
    }
    
    mutating func nextPeriod() -> Bool {
        if isWorkTime {
            isWorkTime = false
            timeRemaining = oneIterationRestTime
            return true
        } else {
            isWorkTime = true
            currentIteration += 1
            if currentIteration >= numberOfIterations {
                return false
            }
            timeRemaining = oneIterationWorkTime
            return true
        }
    }
} 
