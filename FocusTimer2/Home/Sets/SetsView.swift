//
//  SetsView.swift
//  FocusTimer2
//
//  Created by Dostan Turlybek on 10.04.2025.
//

import SwiftUI

struct SetsView: View {
    
    @EnvironmentObject var vm: SetsViewModel
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach($vm.data) { $i in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text($i.name.wrappedValue)
                                .font(.title2)
                                .bold()
                            Button{
                                //редактировать
                            } label:{
                                Image(systemName: "pencil")
                            }
                            Spacer()
                            Button {
                                //cтарт
                            } label: {
                                Image(systemName: "restart")
                                    .font(.title)
                                    .bold()
                            }
                        }
                        
                        switch $i.type.wrappedValue {
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

                .onDelete { vm.data.remove(atOffsets: $0) }
                .onMove { vm.data.move(fromOffsets: $0, toOffset: $1) }
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
        }
    }
}

#Preview {
    FocusTimerView()
}
