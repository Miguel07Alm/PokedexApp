import SwiftUI

class RefreshManager: ObservableObject {
    static let shared = RefreshManager()
    
    @Published var refreshFlag = false
    
    private init() {}
    
    func forceRefresh() {
        refreshFlag.toggle()
    }
}


