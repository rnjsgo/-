import Foundation

final class AppState : ObservableObject {
    @Published var rootViewId = UUID()
}
