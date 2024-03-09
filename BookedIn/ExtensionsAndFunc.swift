//
//  Extensions.swift
//  BookedIn
//
//  Created by Pradeep Poudel on 27/12/2023.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseCore

extension View {
    
    func customTextfield() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .foregroundColor(.gray)
            .padding(1)
        
    }
    
    func customText() -> some View {
        self
            .padding(.horizontal)
            .overlay(Rectangle().frame(height: 1))
            .foregroundColor(Color.gray)
        
    }
    
    
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func linearGradient() -> some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.color.opacity(0.6), Color.color.opacity(1.0)]), startPoint: .top, endPoint: .bottom)
         .ignoresSafeArea()
        
    }
    
    func myImageModifier() -> some View {
        modifier(MyImageFrameModifier())
    }

    
    
    
    
    
    
    
    
}


struct MyImageFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .cornerRadius(40)
        .scaledToFill()
        
        
    }
}

struct Lining : View {
    
    public let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        Rectangle()
            .frame(height: 0.5)
            .foregroundStyle(Color.secondary)
            .padding(.leading, 50)
    }
}




struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage, presentationMode: presentationMode)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        private let presentationMode: Binding<PresentationMode>
        
        init(selectedImage: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
            _selectedImage = selectedImage
            self.presentationMode = presentationMode
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                return
            }
            self.selectedImage = selectedImage
            presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
