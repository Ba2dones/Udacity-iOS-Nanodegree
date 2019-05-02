//
//  ViewController.swift
//  Picker
//
//  Created by Hassan Mostafa on 5/1/19.
//  Copyright © 2019 Hassan Mostafa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    
    // MARK: Meme Model
    struct MemeModel {
        var memeTopText: String
        var memeBottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    // MARK: Meme Text Attributes
    let mememeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
       NSAttributedString.Key.strokeWidth: -3
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topText.defaultTextAttributes = mememeTextAttributes
        bottomText.defaultTextAttributes = mememeTextAttributes
        topText.delegate = self
        bottomText.delegate = self
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        imagePickerView.contentMode = .scaleAspectFit
        start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareButton.isEnabled = imagePickerView.image != nil
        cancelButton.isEnabled = imagePickerView.image != nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Album Picker
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Camera Picker
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextField Editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    // MARK: KEYBOARD Mechanism
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomText.isEditing && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Generate Memed Image
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        toolBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        toolBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        return memedImage
    }
    
    // MARK: Save Memed Image
    func save() {
        // Create the meme
        _ = MemeModel(memeTopText: topText.text!, memeBottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    // MARK: Share Memed Image
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewVC.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewVC, animated: true, completion: nil)
    }
    
    // MARK: Start Over
    func start() {
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        imagePickerView.image = nil
    }
    
    // MARK: Cansel Meme
    @IBAction func cancelMeme(_ sender: Any) {
        start()
        }
    }
