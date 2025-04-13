//
//  SetsView.swift
//  FocusTimer2
//
//  Created by Dostan Turlybek on 10.04.2025.
//

import SwiftUI

struct SetsView: View {
    
    @EnvironmentObject var vm: SetsViewModel
    
    var body: some View {
        NavigationStack{
            List {
                ForEach($vm.data){i in
                    Text("\(i.name)")
                }
                .onDelete { vm.data.remove(atOffsets: $0) }
                .onMove { vm.data.move(fromOffsets: $0, toOffset: $1) }
            }
            .navigationTitle(Text("Sets"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add Button") {
                        SetsCreateView()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    FocusTimerView()
}
