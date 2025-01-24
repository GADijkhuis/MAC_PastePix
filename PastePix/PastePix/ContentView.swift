//
//  ContentView.swift
//  PastePix
//
//  Created by Gideon Dijkhuis on 21/01/2025.
//

import SwiftUI
import Cocoa

struct ContentView: View {
    @State private var image: NSImage? = nil
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        
        VStack{
            Spacer()
            if let image = self.image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("errorNoImgTXT")
            }
            Spacer()
            HStack (spacing: 2){
                Text("Developed by")
                    .font(.footnote)
                Link("GADijkhuis", destination: URL(string: "https://gadijkhuis.nl")!)
                    .font(.footnote)
            }
            
        }
        .toolbar {
            Button("pasteImageBTN") {
                self.pasteImageFromClipboard()
            }
            .keyboardShortcut("v", modifiers: .command)
            
            Button("saveImageBTN") {
                self.saveImage()
            }
            .keyboardShortcut("s", modifiers: .command)
        }
        .navigationTitle("PastePix")
        .frame(minWidth: 600, minHeight: 300)
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
    }

    
    private func pasteImageFromClipboard() {
        let pasteboard = NSPasteboard.general
        if let nsImage = NSImage(pasteboard: pasteboard) {
            self.image = nsImage
        } else {
            self.showErrorAlert(text: "Filetype is incorrect")
        }
    }
    
    
    private func saveImage() {
        if self.image != nil {
            let fileContent = self.image?.tiffRepresentation
            
            let savePanel = NSSavePanel()
            savePanel.title = "Save image"
            savePanel.nameFieldStringValue = "Image"
            savePanel.allowedContentTypes = [.png, .jpeg]
            savePanel.canCreateDirectories = true
            
            savePanel.begin { response in
                if response == .OK, let fileURL = savePanel.url {
                    do {
                        try fileContent?.write(to: fileURL)
                        
                        showSaveAlert()
                    } catch {
                        self.showErrorAlert(text: "Error saving image")
                    }
                }
            }
        }

    }
    
    private func showSaveAlert() {
        alertTitle = "Image Saved"
        alertMessage = "Image succesfully saved"
        showAlert = true
    }
        
    private func showErrorAlert(text: String) {
        alertTitle = "An error occured"
        alertMessage = text
        showAlert = true
    }
}

#Preview {
    ContentView()
}
