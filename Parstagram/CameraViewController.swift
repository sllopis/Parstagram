//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Sergio Llopis on 2/25/19.
//  Copyright © 2019 codepath. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let borderColor = UIColor.black.cgColor
        
        
        commentField.layer.borderColor = borderColor
        commentField.layer.borderWidth = 1.0;
        commentField.layer.cornerRadius = 5.0;
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()
    
        let imageData = imageView.image!.pngData()
        var file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        
        // IF CURRENT IMAGE IS BLANK, DO NOTHING OTHERWISE GO TO THE FUNCTION.
        if (UIImage(named: "image_placeholder") != imageView.image) {
            
            post.saveInBackground { (success, error) in
                if success {
//                    self.dismiss(animated: true, completion: nil)
                    // Reinitializing the file we just saved.
                    file = nil
                      self.performSegue(withIdentifier: "postToFeed", sender: nil)
                    print("saved!")
                } else {
                    print("error!")
                }
            }
        }
        
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        // Changing size of image
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
