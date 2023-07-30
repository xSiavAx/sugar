import SwiftUI

public struct ErrorAlertContext: Identifiable {
    public let id = UUID()

    var title = "Error"
    var details: String

    var retryAction: (() -> Void)?
}

public struct ErrorHandlingViewModifier: ViewModifier {
    @Binding var context: ErrorAlertContext?

    public func body(content: Content) -> some View {
        if context != nil {
            content
                .alert(item: $context) { currentAlert in
                    if currentAlert.retryAction != nil {
                        return Alert(
                            title: Text(currentAlert.title),
                            message: Text(currentAlert.details),
                            primaryButton: .default(Text("Ok")),
                            secondaryButton: .default(Text("Retry"), action: currentAlert.retryAction)
                        )
                    }
                    return Alert(
                        title: Text(currentAlert.title),
                        message: Text(currentAlert.details),
                        dismissButton: .default(Text("Ok"))
                    )
                }
        } else {
            content
        }
    }
}

extension View {
    public func errorHandling(_ context: Binding<ErrorAlertContext?>) -> some View {
        modifier(ErrorHandlingViewModifier(context: context))
    }
}
