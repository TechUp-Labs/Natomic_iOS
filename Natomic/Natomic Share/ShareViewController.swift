//
//  ShareViewController.swift
//  Natomic Share
//
//  Created by Archit Navadiya on 13/05/24.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.isUserInteractionEnabled = false // Disable interaction if the view is invisible
        processSharedContent()
    }
    
    private func processSharedContent() {
        guard let content = extensionContext?.inputItems.first as? NSExtensionItem else {
            cancelExtension(error: "Failed to get extension item")
            return
        }
        
        for attachment in content.attachments ?? [] {
            if attachment.hasItemConformingToTypeIdentifier("public.text") {
                attachment.loadItem(forTypeIdentifier: "public.text", options: nil) { [weak self] (data, error) in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        if let error = error {
                            self.cancelExtension(error: error.localizedDescription)
                            return
                        }
                        
                        if let url = data as? URL, let text = try? String(contentsOf: url) {
                            self.handleSharedText(text)
                        } else if let text = data as? String {
                            self.handleSharedText(text)
                        } else {
                            self.cancelExtension(error: "Expected a text but got something else")
                            return
                        }
                    }
                }
                break // Handle only the first item that conforms to "public.text"
            }
        }
    }
    
    private func handleSharedText(_ text: String) {
        UserDefaults(suiteName: "group.natomic.share")?.set(text, forKey: "sharedText")
        openMainApp()
    }

    private func openMainApp() {
        if let url = URL(string: "natomic://openSpecificView") {
            var responder: UIResponder? = self
            while responder != nil {
                if let application = responder as? UIApplication {
                    application.open(url, options: [:]) { [weak self] success in
                        if success {
                            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                        } else {
                            self?.cancelExtension(error: "Unable to open app")
                        }
                    }
                    break
                }
                responder = responder?.next
            }
        }
    }
    
    private func cancelExtension(error: String) {
        let error = NSError(domain: "ShareExtension", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
        extensionContext?.cancelRequest(withError: error)
    }
}


