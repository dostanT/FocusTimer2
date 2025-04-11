import UIKit

class HapticFeedbackManager {
    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    // Инициализация и подготовка хаптических генераторов
    init() {
        prepareHaptics()
    }
    
    private func prepareHaptics() {
        lightFeedback.prepare()
        mediumFeedback.prepare()
    }
    
    // Легкая хаптическая обратная связь
    func lightImpact() {
        lightFeedback.impactOccurred()
    }
    
    // Средняя хаптическая обратная связь
    func mediumImpact() {
        mediumFeedback.impactOccurred()
    }
}
