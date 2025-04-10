import Foundation


struct StandartModel {
    var workTime: Int
    var breakTime: Int
    var numberOfIterations: Int
    var currentIteration: Int
    var timeRemaining: Int
    var isWorkTime: Bool
    var isRunning: Bool
    
    var progress: Double {
        if isWorkTime {
            return Double(timeRemaining) / Double(workTime)
        } else {
            return Double(timeRemaining) / Double(breakTime)
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
        timeRemaining = workTime
        isRunning = false
    }
    
    mutating func nextPeriod() -> Bool {
        if isWorkTime {
            isWorkTime = false
            timeRemaining = breakTime
            return true
        } else {
            isWorkTime = true
            currentIteration += 1
            if currentIteration >= numberOfIterations {
                return false
            }
            timeRemaining = workTime
            return true
        }
    }
}
