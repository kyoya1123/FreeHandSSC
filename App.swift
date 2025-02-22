import SwiftUI

@main
struct FreeHandApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ListView()
                    .environmentObject(ViewModel())
            }
        }
    }
}
