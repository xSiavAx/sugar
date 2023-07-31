import SwiftUI

extension View {
    public func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(FirstAppear(action: action))
    }
}

public struct FirstAppear: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void

    public func body(content: Content) -> some View {
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
