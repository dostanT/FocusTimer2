//
//  FocusTimerApp.swift
//  FocusTimer
//
//  Created by Dostan Turlybek on 03.04.2025.
//

import SwiftUI

@main
struct FocusTimerApp: App {
    var body: some Scene {
        WindowGroup {
            FocusTimerView()
        }
    }
}

/*
 Описание функциональности приложения Focus Timer:

 Приложение будет основано на TabView, содержащем три вкладки:

 Percentage — {
 import Foundation
 import Combine
 import AudioToolbox
 import UIKit
 import SwiftUI



 struct TimerPerrsentegeModel {
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

 struct TimerPerrsentegeView: View {
     @StateObject private var viewModel = TimerPerrsentegeViewModel()
     
     var body: some View {
         VStack(spacing: 20) {
             Text(viewModel.model.isWorkTime ? "Work Time" : "Rest Time")
                 .font(.title)
                 .foregroundColor(viewModel.model.isWorkTime ? .green : .blue)
             
             ZStack {
                 // Background circle
                 Circle()
                     .stroke(lineWidth: 20)
                     .opacity(0.3)
                     .foregroundColor(viewModel.model.isWorkTime ? .green : .blue)
                 
                 // Progress circle
                 Circle()
                     .trim(from: 0.0, to: CGFloat(viewModel.model.progress))
                     .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                     .foregroundColor(viewModel.model.isWorkTime ? .green : .blue)
                     .rotationEffect(Angle(degrees: 270.0))
                     .animation(.linear, value: viewModel.model.progress)
                 
                 // Time text
                 VStack {
                     Text(viewModel.model.formattedTime)
                         .font(.system(size: 48, weight: .bold))
                     Text(viewModel.model.isWorkTime ? "Work" : "Rest")
                         .font(.headline)
                 }
             }
             .frame(width: viewModel.circleSize, height: viewModel.circleSize)
             .padding()
             .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.model.isRunning)
             
             Text("Iteration \(viewModel.model.currentIteration + 1) of \(viewModel.model.numberOfIterations)")
                 .font(.headline)
                 .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.model.isRunning)
             
             VStack {
                 HStack(spacing: 20) {
                     Button(action: {
                         if viewModel.model.isRunning {
                             viewModel.stopTimer()
                         } else {
                             viewModel.startTimer()
                         }
                     }) {
                         VStack {
                             Text(viewModel.model.isRunning ? "Stop" : "Start")
                                 .font(.headline)
                                 .foregroundColor(.white)
                                 .frame(width: viewModel.model.isRunning ? 200 : 50)
                                 .padding()
                                 .background(viewModel.model.isRunning ? Color.red : Color.green)
                                 .cornerRadius(10)
                                 .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewModel.model.isRunning)
                             if !viewModel.model.isRunning {
                                 Text("\(viewModel.model.oneIterationWorkTime / 60) min")
                                     .foregroundColor(.green)
                             }
                         }
                     }
                     
                     if !viewModel.model.isRunning {
                         Button(action: {
                             viewModel.resetTimer()
                         }) {
                             VStack {
                                 Text("Reset")
                                     .font(.headline)
                                     .foregroundColor(.white)
                                     .padding()
                                     .background(Color.blue)
                                     .cornerRadius(10)
                                 
                                 Text("\(viewModel.model.oneIterationRestTime / 60) min")
                                     .foregroundColor(.blue)
                             }
                         }
                     }
                 }
             }
             
             if !viewModel.model.isRunning {
                 VStack(spacing: 10) {
                     Text("Settings")
                         .font(.headline)
                     HStack(spacing: 30) {
                         VStack {
                             Text("Total Time")
                                 .font(.subheadline)
                             Picker("", selection: Binding(
                                 get: { viewModel.model.totalTime },
                                 set: { viewModel.updateTotalTime($0) }
                             )) {
                                 ForEach(1..<13, id: \.self) { hour in
                                     Text("\(hour) h").tag(hour)
                                 }
                             }
                             .pickerStyle(.wheel)
                             .frame(width: 100)
                         }
                         
                         VStack {
                             Text("Work %")
                                 .font(.subheadline)
                             Picker("", selection: Binding(
                                 get: { viewModel.model.workPercentage },
                                 set: { viewModel.updateWorkPercentage($0) }
                             )) {
                                 ForEach(0..<21) { i in
                                     Text("\(i*5)%").tag(i*5)
                                 }
                             }
                             .pickerStyle(.wheel)
                             .frame(width: 100)
                         }
                         
                         VStack {
                             Text("Iterations")
                                 .font(.subheadline)
                             Picker("", selection: Binding(
                                 get: { viewModel.model.numberOfIterations },
                                 set: { viewModel.updateNumberOfIterations($0) }
                             )) {
                                 ForEach(1..<21) { i in
                                     Text("\(i)").tag(i)
                                 }
                             }
                             .pickerStyle(.wheel)
                             .frame(width: 100)
                         }
                     }
                     .padding(.vertical)
                 }
                 .padding()
                 .background(Color.gray.opacity(0.1))
                 .cornerRadius(10)
                 .transition(.opacity)
                 .animation(.easeInOut, value: viewModel.model.isRunning)
             }
         }
         .padding()
         .onAppear {
             viewModel.resetTimer()
         }
     }
 }


 class TimerPerrsentegeViewModel: ObservableObject {
     @Published private(set) var model: TimerPerrsentegeModel
     private var timer: Timer?
     private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
     private var cancellables = Set<AnyCancellable>()
     
     // Haptic feedback generators
     private let lightFeedback = UIImpactFeedbackGenerator(style: .light)
     private let mediumFeedback = UIImpactFeedbackGenerator(style: .medium)
     private let heavyFeedback = UIImpactFeedbackGenerator(style: .heavy)
     
     init() {
         self.model = TimerPerrsentegeModel(
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

 }
 Standard — классический таймер "помодорро", где пользователь задаёт:
 длительность рабочего интервала;
 длительность отдыха;
 количество итераций.
 Home — содержит:
 сеты таймеров, которые пользователь может создать;
 историю ранее запущенных таймеров (отображаются только те, которые прошли хотя бы одну итерацию).
 Основные условия:

 Пользователь не может запустить более одного таймера одновременно.
 Пользователь может:
 запустить один из таймеров;
 либо остановить все.
 О работе с сетами:

 В Home пользователь может создавать сеты таймеров.
 Каждый сет — это один из двух типов: Percentage или Standard.
 При создании сета пользователь выбирает тип таймера и настраивает параметры таймера (например, длительность рабочего времени, длительность отдыха, количество итераций).
 Эти настройки сохраняются в сете, и при нажатии на сет пользователь будет перенаправлен в соответствующий таймер с заранее установленными значениями.
 В каждом сете будет доступна кнопка редактирования, чтобы пользователь мог изменить настройки таймера.
 История:

 В истории отображаются только те таймеры, которые были запущены хотя бы один раз (то есть завершена минимум одна итерация).
 История сохраняется для анализа и возможного повтора таймеров.
 Темы интерфейса:

 Возможность выбора темы оформления приложения (светлая/тёмная тема).
 Прогресс и статистика:

 Включить функцию для отслеживания прогресса (например, количество завершённых рабочих интервалов).
 Вывод статистики по завершённым сессиям, включая графики или визуализации для анализа производительности пользователя.
 Хранилище:

 Все данные (сеты, история, настройки таймеров) сохраняются через Core Data.

*/
