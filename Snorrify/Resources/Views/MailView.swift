import UIKit
import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    // MARK: - Environment Objects
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    // MARK: - Properties
    
    @Binding
    private var result: Result<MFMailComposeResult, Error>?
    
    private let contract: MailViewContract
    
    // MARK: - Initialization
    
    init(
        result: Binding<Result<MFMailComposeResult, Error>?>,
        contract: MailViewContract
    ) {
        _result = result
        self.contract = contract
    }
    
    // MARK: - View Controller
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> some MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setToRecipients([contract.recipient])
        controller.setSubject(contract.subject)
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {}
}

// MARK: - Coordinator

extension MailView {
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode,
                    result: $result)
    }
    
    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(
            presentationMode: Binding<PresentationMode>,
            result: Binding<Result<MFMailComposeResult, Error>?>
        ) {
            _presentationMode = presentationMode
            _result = result
        }
        
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentationMode.wrappedValue.dismiss()
            }
            if let error = error {
                self.result = .failure(error)
            }
            self.result = .success(result)
        }
    }
}
