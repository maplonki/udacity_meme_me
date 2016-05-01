//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by Hugo Murillo on 4/30/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tabbarShare: UIBarButtonItem!
    @IBOutlet weak var tabbarCamera: UIBarButtonItem!
    @IBOutlet weak var tabbarGallery: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    struct Meme {
        var topText: String!
        var bottomText: String!
        var image: UIImage!
    }
    
    
    var memeModel: Meme!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        memeModel = Meme()
        
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            tabbarCamera.enabled = false
        }
        //By default we disable the share, until we have an image
        tabbarShare.enabled = false
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let labelAttribute = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSParagraphStyleAttributeName : paragraphStyle,
            NSStrokeWidthAttributeName: NSNumber(integer: -3)
        ]
        
        topTextField.defaultTextAttributes = labelAttribute
        bottomTextField.defaultTextAttributes = labelAttribute
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications("keyboardWillShow:", name: UIKeyboardWillShowNotification)
        subscribeToKeyboardNotifications("keyboardWillHide:", name: UIKeyboardWillHideNotification)
        
        if let topText = memeModel.topText {
            topTextField.text = topText
        }
        
        if let bottomText = memeModel.bottomText {
            bottomTextField.text = bottomText
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        subscribeFromKeyboardNotifications(UIKeyboardWillShowNotification)
        subscribeFromKeyboardNotifications(UIKeyboardWillHideNotification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    @IBAction func cameraPressed(sender: AnyObject) {
        launchChooserForSource(.Camera)
    }
    
    @IBAction func galleryPressed(sender: AnyObject) {
        launchChooserForSource(.PhotoLibrary)
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        memeModel.topText = topTextField.text
        memeModel.bottomText = bottomTextField.text
        memeModel.image = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memeModel.image], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            tabbarShare.enabled = true
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    //MARK: - Helper functions
    func launchChooserForSource(source: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        navigationController?.navigationBar.hidden = true
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //We set the mode to graphics in the root view
        UIGraphicsBeginImageContext(self.view.frame.size)
        //We draw all of the childs from the view
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        //We create an image from the graphics mode
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.navigationBar.hidden = false
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    //MARK: - Keyboard Notification callbacks
    func keyboardWillShow(notification:NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }
    
}

