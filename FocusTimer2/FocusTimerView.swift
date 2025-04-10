import SwiftUI


struct FocusTimerView: View {
    
    @State var selectedTab: Int = 0
    
    var body: some View{
        TabView() {
            Tab("", systemImage: "percent") {
                TimerPercentageView()
            }
            
            Tab("", systemImage: "clock") {
                StandartView()
            }
            
            Tab("", systemImage: "percent") {
                TimerPercentageView()
            }
        }
    }
}

#Preview {
    FocusTimerView()
}
