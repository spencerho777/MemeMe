//
//  PictureSelectorViewController.swift
//  MemeMeV2
//
//  Created by Van Nguyen on 7/20/18.
//  Copyright © 2018 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PictureSelectorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIToolbarDelegate{
    
    var image: UIImage?
    @IBOutlet weak var upperToolbar: UIToolbar!
    @IBOutlet weak var lowerToolbar: UIToolbar!
    @IBOutlet weak var cancelMemeButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    
    var topTextField: UITextField!
    var bottomTextField: UITextField!
    
    let memeFontSize: CGFloat = 40.0
    var meme: Meme?
    let attributes = [NSAttributedStringKey.strokeColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "Futura-Bold", size: 40.0)!, NSAttributedStringKey.foregroundColor : UIColor.white.withAlphaComponent(1), NSAttributedStringKey.strokeWidth : -5.0] as [NSAttributedStringKey : Any]
    var imageFrame: CGRect?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if imagePickerView.image == nil{
            shareMemeButton.isEnabled = false
            clearButton.isEnabled = false
        }
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField = UITextField()
        bottomTextField = UITextField()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        upperToolbar.items = [shareMemeButton, space, cancelMemeButton]
        upperToolbar.delegate = self
        
        lowerToolbar.items = [space, albumButton, space, cameraButton, space, clearButton, space]
    }
    
    func setMemeTextFieldParams(_ textField: UITextField, placeholder: String, isVisible: Bool) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        if isVisible {
            textField.borderStyle = .roundedRect
        }
        if textField.text != "" {
            textField.attributedText = NSAttributedString(string: textField.text!, attributes: attributes)
        }
        textField.font = UIFont(name: "Futura-Bold", size: memeFontSize)!
        textField.adjustsFontSizeToFitWidth = true
        textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.textAlignment = NSTextAlignment.center

        textField.delegate = self
    }
    
    func positionTextFields() { // I am kind of emotionally invested in this function, but I will take your advice on future projects
        
        debugPrint("imagePickerView: ", imagePickerView.bounds.minX, imagePickerView.bounds.maxX, imagePickerView.bounds.minY, imagePickerView.bounds.maxY, "Bounds: ", imagePickerView.bounds)
        debugPrint("imagePickerView: ", imagePickerView.bounds)
        
        self.imageFrame = (AVMakeRect(aspectRatio: CGSize(width: imagePickerView.image!.size.width, height: imagePickerView.image!.size.height), insideRect: imagePickerView.bounds))
        
        let height: CGFloat = 40
        
        debugPrint("Image Frame: ", self.imageFrame!)
        
        let aspectRatioY: CGFloat = imagePickerView.bounds.size.height/imagePickerView.image!.size.height
        if ( imagePickerView.bounds.height > imagePickerView.bounds.width ) {
            
            bottomTextField.frame = CGRect(x: 5, y: self.imageFrame!.maxY, width: imagePickerView.bounds.size.width - 10, height: height)
            topTextField.frame = CGRect(x: 5, y: self.imageFrame!.minY + height * 2, width: imagePickerView.bounds.size.width - 10, height: height)
        }
        else {
            bottomTextField.frame = CGRect(x: self.imageFrame!.minX + 5, y: self.imageFrame!.maxY, width: aspectRatioY * imagePickerView.image!.size.width - 10, height: height)
            topTextField.frame = CGRect(x: self.imageFrame!.minX + 5, y: self.imageFrame!.minY + height * 2, width: aspectRatioY * imagePickerView.image!.size.width - 10, height: height)
        }
        print(topTextField.frame)
        print(bottomTextField.frame)
    }
    
    // Keyboard Functions
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Meme Functions
    @IBAction func clearMeme(_ sender: Any) {
        
        shareMemeButton.isEnabled = false
        imagePickerView.image = nil
        topTextField.text = ""
        bottomTextField.text = ""
        topTextField.removeFromSuperview()
        bottomTextField.removeFromSuperview()
        meme = nil
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        upperToolbar.isHidden = true
        lowerToolbar.isHidden = true
        
        if view.frame.origin.y != 0 {
            resignFirstResponder()
        }
        
        self.imageFrame! = (AVMakeRect(aspectRatio: CGSize(width: imagePickerView.image!.size.width, height: imagePickerView.image!.size.height), insideRect: imagePickerView.bounds))
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        upperToolbar.isHidden = false
        lowerToolbar.isHidden = false
        
        return memedImage.crop(rect: CGRect(x: self.imageFrame!.minX, y: self.imageFrame!.minY + 44 + UIApplication.shared.statusBarFrame.height, width: self.imageFrame!.width, height: self.imageFrame!.height))
    }

    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
                
                let alert = UIAlertController(title: "Would you like to save this meme to your photos?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    UIImageWriteToSavedPhotosAlbum(memedImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.memes.append(self.meme!)
                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.memes.append(self.meme!)
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true)
            }
        }
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    // Selecting Picture Functions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        pick(sourceType: .photoLibrary)
    }
    
    func pick(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pick(sourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image

            positionTextFields()
            
            setMemeTextFieldParams(bottomTextField, placeholder: "BOTTOM", isVisible: false)
            setMemeTextFieldParams(topTextField, placeholder: "TOP", isVisible: false)
            self.view.addSubview(topTextField)
            self.view.addSubview(bottomTextField)
            shareMemeButton.isEnabled = true
            clearButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    // Device Rotation Function
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if imagePickerView.image != nil {
            positionTextFields()
        }
    }
    
    // TextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! == "" {
            var placeholder = "TOP"
            if textField == bottomTextField {
                placeholder = "BOTTOM"
            }
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newString: String = textField.text!
        
        if textField.text != "" && string == "" {
            newString = String(newString.dropLast())
        }
        else {
            newString = newString + string
        }
        textField.attributedText = NSAttributedString(string: newString, attributes: attributes)
        return false
    }
    
    // Toolbar Delegate Functions
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}

