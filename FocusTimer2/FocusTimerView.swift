import SwiftUI


struct FocusTimerView: View {
    
    @StateObject var vm: FocusTimerViewModel = .init()
    @StateObject var vmForSets = SetsViewModel()
    
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
            } label: {
                Image(systemName: "house")
            }
            
            Tab(value: 1) {
                StandartView()
            } label: {
                Image(systemName: "clock")
            }
            
            Tab(value: 2) {
                TimerPercentageView()
            } label: {
                Image(systemName: "percent")
            }
            
            
            Tab(value: 3) {
                HistoryView()
            } label: {
                Image(systemName: "globe")
            }
            
           
        }
    }
}

#Preview {
    FocusTimerView()
}
