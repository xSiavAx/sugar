import Foundation
import SwiftUI

public struct ActivityDimmingViewModifier: ViewModifier {
    @Binding var isDimmed: Bool
    var color: Color

    public init(isDimmed: Binding<Bool>, color: Color) {
        self._isDimmed = isDimmed
        self.color = color
    }

    public func body(content: Content) -> some View {
        if isDimmed {
            ZStack {
                content
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(color)
                .ignoresSafeArea()
            }
        } else {
            content
        }
    }
}

extension View {
    public func activityDimming(_ isDimmed: Binding<Bool>, color: Color = .gray.opacity(0.6)) -> some View {
        modifier(ActivityDimmingViewModifier(isDimmed: isDimmed, color: color))
    }
}
