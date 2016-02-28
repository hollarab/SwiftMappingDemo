//
//  ABHHelper.swift
//
//  Created by hollarab on 10/28/15.
//  Copyright © 2015 LameSauce Software. All rights reserved.
//

import Foundation           // for NSString
import UIKit                // For UIImage stuff
import MobileCoreServices   // For kUTTypeImage

//MARK: Array Extensions
extension Array where Element: Equatable {
    mutating public func removeObject(object:Element) {
        if let index = self.indexOf(object){
            self.removeAtIndex(index)
        }
    }
    
    mutating public func removeObjects(array:[Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

//MARK: Numeric Extensions
extension Int {
    /**
     formats value w/ printf style format string
     
     - Parameters:
     - f: format string.  10 w/ format '0.4' would pad two zeros left: "0010"
     - Returns: number as a string with given format
     */
    public func format(f: String) -> String {
        return NSString(format: "%\(f)d", self) as String
    }
}

extension Double {
    /**
     formats value w/ printf style format string
     
     - Parameters:
     - f: format string.  0.333 w/ format '0.2' would yield 0.33
     - Returns: number as a string with given format
     */
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension Float {
    /**
    formats value w/ printf style format string
     
     - Parameters:
        - f: format string.  0.333 w/ format '0.2' would yield 0.33
     - Returns: number as a string with given format
    */
    public func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}


//MARK: Documents directory access
func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func pathToFileInDocumentsDirectory(filename: String) -> String {
    return getDocumentsDirectory().stringByAppendingPathComponent(filename)
}

func pathToExistingFileInDocumentsDirectory(filename:String) -> String? {
    let path = pathToFileInDocumentsDirectory(filename)
    let checkValidation = NSFileManager.defaultManager()
    if (checkValidation.fileExistsAtPath(path)) {
        return path
    } else {
        return nil
    }
}


//MARK: UIImage extensions
extension UIImage {
    /// Creates an image that will fit inside the given rectangle (won't work in Playground)
    public func scaledInside(maxSize:CGSize) -> UIImage? {
        
        let cgImage = self.CGImage
        
        let aspectWidth:CGFloat  = maxSize.width / self.size.width;
        let aspectHeight:CGFloat = maxSize.height / self.size.height;
        let aspectRatio:CGFloat  = min( aspectWidth, aspectHeight );
        
        let width:Int = Int(self.size.width * aspectRatio);
        let height:Int = Int(self.size.height * aspectRatio);
        
        let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
        let bytesPerRow = CGImageGetBytesPerRow(cgImage)
        let colorSpace = CGImageGetColorSpace(cgImage)
        let bitmapInfo = CGImageGetBitmapInfo(cgImage)
        
        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
        
        CGContextSetInterpolationQuality(context, .High)
        
        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: CGSize(width: CGFloat(width), height: CGFloat(height))), cgImage)
        
        let scaledImage = CGBitmapContextCreateImage(context).flatMap { UIImage(CGImage: $0) }
        return scaledImage
        
    }
    
    /// Helper that is sometimes needed when pulling assets from camera roll to make sure orientation is set correctly  (won't work in Playground)
    public func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImageOrientation.Up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.drawInRect(rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
}

//MARK: Image Capture Helpers

/// When on device, prompts user to choose between camera roll and photos.  On simulartor, just goes to photos.
public func ABHPresentImageCapture<T: UIViewController where T:UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(controller:T) {
    if UIImagePickerController.isSourceTypeAvailable(.Camera)
    {
        let alertController = UIAlertController(title: "Add Image", message: "Please choose a source", preferredStyle: .Alert)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (_) in
            let picker = UIImagePickerController()
            picker.mediaTypes = [kUTTypeImage as String]
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.allowsEditing = false;
            picker.delegate = controller;
            controller.presentViewController(picker, animated: true, completion: nil)
        }
        
        let rollAction = UIAlertAction(title: "Camera Roll", style: .Default) { (_) in
            let picker = UIImagePickerController()
            picker.allowsEditing = false;
            picker.delegate = controller;
            controller.presentViewController(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addAction(cameraAction)
        alertController.addAction(rollAction)
        alertController.addAction(cancelAction)
        controller.presentViewController(alertController, animated: true) {}
    } else {
        let picker = UIImagePickerController()
        picker.allowsEditing = false;
        picker.delegate = controller;
        controller.presentViewController(picker, animated: true, completion: nil)
    }
}

/// When on device, goes straight to the camera.  On simulartor, goes to photos.
public func ABHPresentCamera<T: UIViewController where T:UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(controller:T) {
    if UIImagePickerController.isSourceTypeAvailable(.Camera)
    {
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.allowsEditing = false;
        picker.delegate = controller;
        controller.presentViewController(picker, animated: true, completion: nil)
    } else {
        let picker = UIImagePickerController()
        picker.allowsEditing = false;
        picker.delegate = controller;
        controller.presentViewController(picker, animated: true, completion: nil)
    }
}


//MARK: UIAlertController conveniences

/// Creates simple alert controller with text input, ok and cancel callbacks
public func ABHAlertFor(controller:UIViewController, title:String, message:String,
    okCallback:(()->Void), cancelCallback:(()->Void)?) {
        let alertController = UIAlertController(title:title, message:message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            if let callback = cancelCallback {
                callback()
            }
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            okCallback()
        }
        alertController.addAction(OKAction)
        
        controller.presentViewController(alertController, animated: true, completion:nil)
}




/// Creates simple alert controller with text input, ok and cancel callbacks
public func ABHAlertTextFor(controller:UIViewController, title:String, message:String, placeholder:String,
    okCallback:((string:String)->Void), cancelCallback:(()->Void)?) {
    let alertController = UIAlertController(title:title, message:message, preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        if let callback = cancelCallback {
            callback()
        }
    }
    alertController.addAction(cancelAction)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        let textField = alertController.textFields![0] as UITextField
        okCallback(string: textField.text!)
    }
    alertController.addAction(OKAction)
    
    alertController.addTextFieldWithConfigurationHandler { (textField) in
        textField.placeholder = placeholder
    }
    
    controller.presentViewController(alertController, animated: true, completion:nil)
}


protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(self, options: nil).first as! Self
    }
    
}

