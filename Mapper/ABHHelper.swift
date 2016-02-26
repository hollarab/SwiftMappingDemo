//
//  ABHHelper.swift
//  HomeChoice
//
//  Created by hollarab on 10/28/15.
//  Copyright © 2015 LameSauce Software. All rights reserved.
//

import UIKit
import MobileCoreServices

///--------------------------------------
/// @name Blocks
///--------------------------------------
public typealias ABHBoolMessageBlock = (Bool, String?) -> Void
public typealias ABHBoolErrorBlock = (Bool, NSError?) -> Void



func ABHdelay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func ABHasnycMain(closure:()->()) {
    dispatch_async(dispatch_get_main_queue(), closure)
}

func ABHasnycDefault(closure:()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure)
}

func ABHasnycHigh(closure:()->()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), closure)
}

public func ABHPresentImageCapture<T: UIViewController where T:UIImagePickerControllerDelegate, T:UINavigationControllerDelegate>(controller:T) {
    if UIImagePickerController.isSourceTypeAvailable(.Camera)
    {
        let alertController = UIAlertController(title: "New Home Image", message: "", preferredStyle: .Alert)
        
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


public func ABHAlertTextFor(controller:UIViewController, title:String, message:String, placeholder:String, okCallback:((string:String)->Void), cancelCallback:(()->Void)?) {
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


extension Array where Element: Equatable {
    mutating func removeObject(object:Element) {
        if let index = self.indexOf(object){
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjects(array:[Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

import Foundation

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self) as String
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension UIImage {
    func scaledInside(maxSize:CGSize) -> UIImage? {
        
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
    
    func normalizedImage() -> UIImage {

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