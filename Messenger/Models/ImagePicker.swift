//
//  ImagePicker.swift
//  Messenger
//
//  Created by Florian Zitlau on 10.04.22.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //nothing
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: ImagePicker
    
    init(_ picker: ImagePicker) {
        self.parent = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Run the code when the user has selected an image
        print("selected")
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //able to get the image
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        
        //Dismiss the picker
        parent.isPickerShowing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Run code when user has cancelled the picker UI
        print("cancelled")
        
        //Dismiss the picker
        parent.isPickerShowing = false
    }
}


//Code in Klasse wo ImagePicker benutz wird:
/*
 
 @State var selectedImage: UIImage?
 @State var isPickerShowing = false
 
 //wo image angezeigt werden soll
 if selectedImage != nil {
     Image(uiImage: selectedImage!)
 }
 
 //Button zum öffnen des ImagePickers
 Button {
     //show the image picker
     isPickerShowing = true
     
 }
 
 //nach dem V/H/Z Stack bspw.
 .sheet(isPresented: $isPickerShowing, onDismiss: nil) {
     ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
     
 }
 
 
 */
