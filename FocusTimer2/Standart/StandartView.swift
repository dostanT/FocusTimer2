
//
//  ContentView.swift
//  FocusTimer
//
//  Created by Dostan Turlybek on 03.04.2025.
//

import SwiftUI
import AudioToolbox
import Combine

struct StandartView: View {
    @StateObject private var viewModel = StandartViewModel()
    
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
                                Text("\(viewModel.model.workTime / 60) min")
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
                                
                                Text("\(viewModel.model.breakTime / 60) min")
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
                            Text("Work Time")
                                .font(.subheadline)
                            Picker("", selection: Binding(
                                get: { viewModel.model.workTime / 60 },
                                set: { viewModel.updateWorkTime($0)}
                            )) {
                                ForEach(1..<13, id: \.self) { min in
                                    Text("\(min*10)min").tag(min*10)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 100)
                        }
                        
                        VStack {
                            Text("Break Time")
                                .font(.subheadline)
                            Picker("", selection: Binding(
                                get: { viewModel.model.breakTime / 60},
                                set: { viewModel.updateBreakTime($0) }
                            )) {
                                ForEach(0..<21) { min in
                                    Text("\(min*5)min").tag(min*5)
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

#Preview {
    StandartView()
}

