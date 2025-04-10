import Foundation
import Combine
import AudioToolbox
import UIKit

class TimerPercentageViewModel: ObservableObject {
    @Published private(set) var model: TimerPercentageModel
    private var timer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var cancellables = Set<AnyCancellable>()
    
    // Haptic feedback generators
    private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
    private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    init() {
        self.model = TimerPercentageModel(
            totalTime: 1,
            workPercentage: 80,
            numberOfIterations: 1,
            currentIteration: 0,
            timeRemaining: 0,
            isWorkTime: true,
            isRunning: false
        )
        setupNotifications()
        prepareHaptics()
    }
    
    private func prepareHaptics() {
        lightFeedback.prepare()
        mediumFeedback.prepare()
        heavyFeedback.prepare()
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
    
    func updateTotalTime(_ hours: Int) {
        model.totalTime = hours
        resetTimer()
    }
    
    func updateWorkPercentage(_ percentage: Int) {
        model.workPercentage = percentage
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

/*
Инструкция по добавлению месячной подписки через RevenueCat:

1. Установка RevenueCat:
   - Добавьте в Package.swift:
     .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.0.0")
   - Или через SPM в Xcode: File -> Add Packages -> https://github.com/RevenueCat/purchases-ios.git

2. Инициализация в AppDelegate или @main:
   import RevenueCat
   
   Purchases.configure(withAPIKey: "your_api_key")
   Purchases.logLevel = .debug // Только для разработки

3. Создание продукта в App Store Connect:
   - Перейдите в App Store Connect -> Ваше приложение -> Функции -> Покупки в приложении
   - Создайте новый продукт типа "Автоматически обновляемая подписка"
   - Установите идентификатор продукта (например, "com.yourapp.monthly")
   - Настройте цену и другие параметры подписки

4. Настройка в RevenueCat Dashboard:
   - Создайте новый продукт с тем же идентификатором
   - Настройте период подписки (месяц)
   - Свяжите с App Store Connect

5. Добавление кода для работы с подпиской:
   
   // В TimerViewModel:
   private var purchases: Purchases?
   
   func setupPurchases() {
       purchases = Purchases.shared
       purchases?.delegate = self
   }
   
   func purchaseSubscription() async throws {
       let offerings = try await purchases?.offerings()
       guard let package = offerings?.current?.availablePackages.first else {
           throw NSError(domain: "No packages available", code: -1)
       }
       
       let result = try await purchases?.purchase(package: package)
       // Обработка результата покупки
   }
   
   func restorePurchases() async throws {
       let customerInfo = try await purchases?.restorePurchases()
       // Обработка восстановленных покупок
   }
   
   // Проверка статуса подписки
   func checkSubscriptionStatus() async throws -> Bool {
       let customerInfo = try await purchases?.customerInfo()
       return customerInfo?.entitlements["premium"]?.isActive == true
   }

6. Добавление UI для подписки:
   - Создайте экран с информацией о подписке
   - Добавьте кнопки "Купить" и "Восстановить покупки"
   - Показывайте разный контент в зависимости от статуса подписки

7. Тестирование:
   - Используйте тестовые аккаунты в App Store Connect
   - Включите режим отладки RevenueCat
   - Проверьте все сценарии: покупка, отмена, восстановление

8. Публикация:
   - Настройте сертификаты и профили
   - Загрузите приложение в App Store Connect
   - Дождитесь проверки подписки Apple

Дополнительные рекомендации:
- Добавьте обработку ошибок
- Реализуйте кэширование статуса подписки
- Добавьте аналитику покупок
- Настройте уведомления о событиях подписки
- Реализуйте промокоды и специальные предложения
*/ 
