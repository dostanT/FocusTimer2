import Foundation
import Combine
import AudioToolbox
import UIKit


class StandartViewModel: ObservableObject {
    @Published private(set) var model: StandartModel
    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var cancellables = Set<AnyCancellable>()
    
    // Haptic feedback generators
    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    init() {
        self.model = StandartModel(
            workTime: 30 * 60,
            breakTime: 30 * 60,
            numberOfIterations: 2,
            currentIteration: 0,
            timeRemaining: 30 * 60,
            isWorkTime: true,
            isRunning: false
        )
        setupNotifications()
        prepareHaptics()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                if self?.model.isRunning == true {
                    self?.startBackgroundTask()
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.endBackgroundTask()
            }
            .store(in: &cancellables)
    }
    
    private func startBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    private func prepareHaptics() {
        lightFeedback.prepare()
        mediumFeedback.prepare()
        heavyFeedback.prepare()
    }
    
    private func playAlarm() {
        DispatchQueue.global(qos: .userInitiated).async {
            AudioServicesPlaySystemSound(1005)
        }
    }
    
    func startTimer() {
        model.isRunning = true
        mediumFeedback.impactOccurred()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            DispatchQueue.global(qos: .userInitiated).async {
                if self.model.timeRemaining > 0 {
                    DispatchQueue.main.async {
                        self.model.timeRemaining -= 1
                    }
                } else {
                    self.playAlarm()
                    DispatchQueue.main.async {
                        if !self.model.nextPeriod() {
                            DispatchQueue.main.async {
                                self.stopTimer()
                            }
                        }
                    }
                }
            }

        }
    }
    
    func stopTimer() {
        model.isRunning = false
        timer?.invalidate()
        timer = nil
        endBackgroundTask()
        heavyFeedback.impactOccurred()
    }
    
    func resetTimer() {
        stopTimer()
        model.reset()
        lightFeedback.impactOccurred()
    }
    
    func updateWorkTime(_ minutes: Int) {
        model.workTime = minutes * 60
        resetTimer()
    }

    func updateBreakTime(_ minutes: Int) {
        model.breakTime = minutes * 60
        resetTimer()
    }
    
    func updateNumberOfIterations(_ iterations: Int) {
        model.numberOfIterations = iterations
        resetTimer()
    }
    
    var circleSize: CGFloat {
        model.isRunning ? 300 : 250
    }
}
