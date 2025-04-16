import SwiftUI


struct FocusTimerView: View {
    
    @StateObject var vm: FocusTimerViewModel = .init()
    @StateObject var vmForSets = SetsViewModel()
    @StateObject var vmPercentage: TimerPercentageViewModel = .init()
    @StateObject var vmStandart: StandartViewModel = .init()
    var body: some View{
//        TabView() {
//            Tab("", systemImage: "percent") {
//                TimerPercentageView()
//            }
//            
//            Tab("", systemImage: "clock") {
//                StandartView()
//            }
//            
//            Tab("", systemImage: "house") {
//                SetsView()
//            }
//        }

        TabView(selection: $vm.selectedTab) {
            Tab(value: 0) {
                SetsView()
                    .environmentObject(vmForSets)
                    .environmentObject(vmPercentage)
                    .environmentObject(vmStandart)
                    
            } label: {
                Image(systemName: "house")
            }
            Tab(value: 1) {
                StandartView()
                    .environmentObject(vmStandart)
            } label: {
                Image(systemName: "clock")
            }
            
            Tab(value: 2) {
                TimerPercentageView()
                    .environmentObject(vmPercentage)
            } label: {
                Image(systemName: "percent")
            }
            
            
            Tab(value: 3) {
                HistoryView()
            } label: {
                Image(systemName: "globe")
            }
        }
        .environmentObject(vm)
    }
}

#Preview {
    FocusTimerView()
}
