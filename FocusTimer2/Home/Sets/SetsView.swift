//
//  SetsView.swift
//  FocusTimer2
//
//  Created by Dostan Turlybek on 10.04.2025.
//

import SwiftUI

struct SetsView: View {
    
    @EnvironmentObject var vm: SetsViewModel
    @EnvironmentObject var vmMain: FocusTimerViewModel
    @EnvironmentObject var vmPercentage: TimerPercentageViewModel
    @EnvironmentObject var vmStandart: StandartViewModel
    
    @State var showSheet: Bool = false
    @State var showEditSheet: Bool = false
    @State var selectedSet: SetsModel? = nil
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach($vm.data) { i in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(i.name.wrappedValue)
                                .font(.title2)
                                .bold()
                            Button{
                                selectedSet = i.wrappedValue
                                showEditSheet = true
                            } label:{
                                Image(systemName: "pencil")
                            }
                            Spacer()
                            Button {
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
                                switch i.type.wrappedValue {
                                case .percentage(let model):
                                    vmPercentage.model = TimerPercentageModel(
                                        totalTime: model.totalTime,
                                        workPercentage: model.workPercentage,
                                        numberOfIterations: model.numberOfIterations,
                                        currentIteration: 0,
                                        timeRemaining: 0,
                                        isWorkTime: true,
                                        isRunning: false)
                                    DispatchQueue.main.async{
                                        vmMain.selectedTab = 2
                                    }
                                case .standart(let model):
                                    vmStandart.model = StandartModel(
                                        workTime: model.workTime * 60,
                                        breakTime: model.breakTime * 60,
                                        numberOfIterations: model.numberOfIterations,
                                        currentIteration: 0,
                                        timeRemaining: 0,
                                        isWorkTime: true,
                                        isRunning: false)
                                    
                                    DispatchQueue.main.async {
                                        vmMain.selectedTab = 1
                                    }
                                }
                            } label: {
                                Image(systemName: "restart")
                                    .font(.title)
                                    .bold()
                            }
                        }
                        
                        switch i.type.wrappedValue {
                        case .percentage(let model):
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Percetage timer")
                                    .font(.subheadline)
                                Text("Time: \(model.totalTime) ч")
                                Text("Work percetage: \(model.workPercentage)%")
                                Text("Iterations: \(model.numberOfIterations)")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)

                        case .standart(let model):
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Standart timer")
                                    .font(.subheadline)
                                Text("Work: \(model.workTime) мин")
                                Text("Break: \(model.breakTime) мин")
                                Text("Iterations: \(model.numberOfIterations)")
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .navigationTitle(Text("Sets"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        showSheet.toggle()
                    }label:{
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                SetsCreateView(showSheet: $showSheet)
            }
            .sheet(item: $selectedSet) { set in
                switch set.type {
                case .percentage(let model):
                    SetsUpdateView(
                        selectedSet: $selectedSet, // или можно убрать его вовсе
                        name: set.name,
                        type: 0,
                        totalTime: model.totalTime,
                        workPercentage: model.workPercentage,
                        numberOfIterations: model.numberOfIterations
                    )
                case .standart(let model):
                    SetsUpdateView(
                        selectedSet: $selectedSet,
                        name: set.name,
                        type: 1,
                        workTime: model.workTime,
                        breakTime: model.breakTime,
                        numberOfIterations: model.numberOfIterations
                    )
                }
            }
        }
    }
}

#Preview {
    FocusTimerView()
}
