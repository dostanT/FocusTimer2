//
//  SetsCreateView.swift
//  FocusTimer2
//
//  Created by Dostan Turlybek on 13.04.2025.
//

import SwiftUI

struct SetsCreateView: View {
    @EnvironmentObject var vm: SetsViewModel
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack{
            VStack{
                
                TextField("New Set", text: $vm.name)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                
                Picker(selection: $vm.type) {
                    Text("Percantage Timer")
                        .tag(0)
                    Text("Standart Timer")
                        .tag(1)
                } label: {
                    Text("This is picker for timer")
                }
                .pickerStyle(PalettePickerStyle())
                .padding()
                
                HStack{
                    if vm.type == 0{
                        VStack{
                            Text("Total Time")
                                .font(.caption)
                            Picker("TotalTime", selection: $vm.totalTime) {
                                ForEach(1..<13, id: \.self) { hour in
                                    Text("\(hour) h").tag(hour)
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        }
                        
                        VStack{
                            Text("Percentage of work")
                                .font(.caption)
                            Picker("Percantage", selection: $vm.workPercentage) {
                                ForEach(0..<21) { i in
                                    Text("\(i*5)%").tag(i*5)
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        }
                        
                        VStack{
                            Text("Iterations")
                                .font(.caption)
                            Picker("NumberOfIteration", selection: $vm.numberOfIterations) {
                                ForEach(1..<21) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        }
                        
                    }
                    else if vm.type == 1{
                        VStack{
                            Text("Work")
                                .font(.caption)
                            Picker("Work", selection: $vm.workTime) {
                                ForEach(1..<13, id: \.self) { min in
                                    Text("\(min*10)min").tag(min*10)
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        }
                        
                        VStack{
                            Text("Break")
                                .font(.caption)
                            Picker("Break", selection: $vm.breakTime) {
                                ForEach(1..<13, id: \.self) { min in
                                    Text("\(min*10)min").tag(min*10)
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        }
                        
                        VStack{
                            Text("Iterations")
                                .font(.caption)
                            Picker("Iterations", selection: $vm.numberOfIterations) {
                                ForEach(1..<21) { i in
                                    Text("\(i)").tag(i)
                                }
                            }
                            .pickerStyle(InlinePickerStyle())
                        }
                    }
                    
                }
                
                Button{
                    if vm.name == "" {
                        vm.name = "New Set"
                        vm.add()
                        showSheet = false
                    }
                    else{
                        vm.add()
                        showSheet = false
                    }
                } label: {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            
            .navigationTitle("\(vm.name == "" ? "New Set" : vm.name)")
        }
    }
}

