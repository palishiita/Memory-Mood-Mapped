import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selection = 0
    @StateObject var locationManager = LocationManager() // Create an instance
    @State private var isShowingOpeningView = true
    
    var body: some View {
        
        if isShowingOpeningView {
            OpeningSlidesView(isShowingOpeningView: $isShowingOpeningView)
        } else {
            TabView(selection: $selection) {
                MoodView()
                    .environmentObject(locationManager) // Inject LocationManager here
                    .tabItem {
                        Label("Mood", systemImage: "smiley")
                    }
                    .tag(0)
                
                MemoryView()
                    .environmentObject(locationManager) // Inject LocationManager here
                    .tabItem {
                        Label("Memory", systemImage: "heart")
                    }
                    .tag(1)
                
                MapView()
                    .environmentObject(locationManager)
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                    .tag(2)
                    .accessibility(identifier: "MapView") // Set the identifier
            }
            
            .accentColor(.black)
            .onAppear {
                configureNavigationBarAppearance()
            }
        }
        
        
        
    }
    
    func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
