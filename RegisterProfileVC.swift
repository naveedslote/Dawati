//
//  RegisterProfileVC.swift
//  Login
//
//  Created by Jigar Patel on 27/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire

class RegisterProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,IQActionSheetPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var imageSaved : NSString = ""
    let imagePicker = UIImagePickerController()
    var imgBase64 = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPolicy: UILabel!
    
    @IBOutlet var txtGender: UITextField!
    @IBOutlet var txtDOB: UITextField!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var viewText: UIView!
    
    var cityCode = ""
    var countryCode = ""
    
    let sharedObj = SharedClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtGender.inputAccessoryView = toolbar
        self.txtDOB.inputAccessoryView = toolbar
        
        
        txtGender.text = AppUtility.sharedInstance.getStringFromDefaults(key: "gender")
        txtDOB.text = AppUtility.sharedInstance.getStringFromDefaults(key: "birthday")
        
        txtGender.attributedPlaceholder = NSAttributedString(string:"Gender", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        txtDOB.attributedPlaceholder = NSAttributedString(string:"Date of Birth", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        
        
        
        
        
        imagePicker.delegate = self
        
        tapGestureOnTextView()
        roundCornerButton()
        
        let imageProfile = AppUtility.sharedInstance.getImageFromDirectory(filename: "image_Profile")
        
        if imageProfile != nil
        {
            btnProfile.setImage(imageProfile, for: .normal)
            
            let imagecropped = self.resizeImage(image: imageProfile!, targetSize: CGSize(width: 200, height: 200))
            let imageData:NSData = UIImagePNGRepresentation(imagecropped)! as NSData
            
           // let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: NSData.Base64EncodingOptions.RawValue (0)))
            print(strBase64)
            
            imgBase64 = strBase64
        }
        
        
        
        
        separateColorOfTitle()
        
        // Do any additional setup after loading the view.
    }
    
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func tapGestureOnTextView()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleTap(sender:)))
        tap.delegate = self as UIGestureRecognizerDelegate
        self.viewText.addGestureRecognizer(tap)
    }
    
    func HandleTap(sender: UITapGestureRecognizer? = nil) {
        let arrButtons = ["Male","Female"]
        let intervalActionSheet = UIAlertController(title: "Select Gender:", message: "", preferredStyle: .actionSheet)
        
        for i in 0..<arrButtons.count
        {
            intervalActionSheet.addAction(UIAlertAction(title: arrButtons[i], style: UIAlertActionStyle.default, handler: handleActionSheet))
        }
        intervalActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        
        //CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.present(intervalActionSheet, animated: true, completion:nil)
        
    }
    
    // Mark: - Button Click Functions
    
    @IBAction func btnProfileClicked(_ sender: Any)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Camera")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: "Albums", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Albums")
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func dictionaryToJson(dictionary:NSDictionary)->String
    {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: [])
        {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            return theJSONText!
        }
        
        return ""
    }
    @IBAction func btnSignUpClicked(_ sender: Any)
    {
        
        SignUpWebServiceCall()
    }
    
    // MARK: - WebServiceCall
    func SignUpWebServiceCall(){
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        var intGender = 0
        
        if txtGender.text == "Male"
        {
            intGender = 1
        }
        else
        {
            intGender = 0
        }
        
        if imgBase64 != ""
        {
            imgBase64 =   "data:image/png;base64," + imgBase64
        }
        
       /* 
         let parameters = ["FirstName": AppUtility.sharedInstance.getStringFromDefaults(key: "firstname"),"LastName":AppUtility.sharedInstance.getStringFromDefaults(key: "lastname"),"EmailAddress": AppUtility.sharedInstance.getStringFromDefaults(key: "email"),"Password": AppUtility.sharedInstance.getStringFromDefaults(key: "password"),"DOB": txtDOB.text!,"Gender": intGender,"ProfilePic": imgBase64 ,
                          "CountryID" : countryCode , "CityID" : cityCode ] as [String : Any]
        */
        
        let parameters = ["FirstName": AppUtility.sharedInstance.getStringFromDefaults(key: "firstname"),"LastName":AppUtility.sharedInstance.getStringFromDefaults(key: "lastname"),"EmailAddress": AppUtility.sharedInstance.getStringFromDefaults(key: "email"),"Password": AppUtility.sharedInstance.getStringFromDefaults(key: "password"),"DOB": txtDOB.text!,"Gender": intGender ,"ProfilePic": imgBase64 ,
                          "CountryID" : countryCode , "CityID" : cityCode ] as [String : Any]
        
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: [])
        {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print(theJSONText)
        }
        
        let urlString = "http://dawati.net/api/dawati-register"
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {response in
            
            print("apicall")
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            switch response.result {
            case .success:
                print(response)
                
                let responseDict = response.result.value as? NSObject
                
                if responseDict == nil{
                }
                else{
                    let dict = response.value as! NSDictionary
                    print(dict)
                    
                    let success = dict.value(forKey: "success") as AnyObject
                    let status = "\(success)" as NSString
                    if status.isEqual(to: "1") {

                    
                    //                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    //                    }
                    //                    else if status.isEqual(to: "0") {
                    let message = dict.value(forKey: "message") as! String
                    //self.alertView("Dawati", strMessage: message)
                    
                    let uiAlert = UIAlertController(title: "Dawati", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        let objActivationVC = self.storyboard?.instantiateViewController(withIdentifier: "ActivationVC") as! ActivationVC
                        self.navigationController?.pushViewController(objActivationVC, animated: true)
                        
                    }))
                        
                    }else if status.isEqual(to: "0") {
                        
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                    
                    
                    //   }
                }
                
                break
            case .failure(let error):
                print(error)
                Constant.sharedObj.alertView("Dawati", strMessage: "Signup failed")
            }
        }
    }
    
    
    func alertView(_ strTitle:String,strMessage:String)
    {
        // let alert:UIAlertView = UIAlertView(title: strTitle as String, message: strMessage as String, delegate: nil, cancelButtonTitle: "Ok")
        
        let alert = UIAlertController(title: strTitle as String, message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler:
            { action in
                
                self.navigationController?.popToRootViewController(animated: true)
        }))
        
        DispatchQueue.main.async(execute:
            {
                self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    // Mark: - Other Function
    func roundCornerButton(){
        self.btnSignUp.layer.cornerRadius = 5
        self.btnProfile.layer.cornerRadius = self.btnProfile.frame.width/2
        btnProfile.contentMode = .scaleAspectFill
        btnProfile.layer.cornerRadius = self.btnProfile.frame.width/2
        btnProfile.clipsToBounds = true
        
    }
    
    func separateColorOfTitle() {
        var myString = NSString()
        myString = "Wellcome to Dawati, User,\nComplete your profile by filling out the details below."
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "arial", size: 14.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:26
            ,length:5))
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:1.0, green:1.0, blue:1.0, alpha:0.7), range: NSRange(location:26
            ,length:55))
        
        var myString1 = NSString()
        myString1 = "By taping  \"Sign Up\", you agree to the Dawati Terms of Service\n and Privarcy Policy"
        var myMutableString1 = NSMutableAttributedString()
        
        myMutableString1 = NSMutableAttributedString(string: myString1 as String, attributes: [NSFontAttributeName:UIFont(name: "arial", size: 11.0)!])
        //        myMutableString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:39
        //            ,length:5))
        
        myMutableString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.09, green:0.41, blue:0.52, alpha:1.0), range: NSRange(location:38
            ,length:24))
        
        myMutableString1.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.09, green:0.41, blue:0.52, alpha:1.0), range: NSRange(location:68
            ,length:15))
        
        
        self.lblPolicy.attributedText = myMutableString1
        
        
        self.lblTitle.attributedText = myMutableString
    }
    
    // MARK: - imagePickerController Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            //let imagecropped = cropToBounds(image: pickedImage, width: 50, height: 50)
            
            let imagecropped = self.resizeImage(image: pickedImage, targetSize: CGSize(width: 200, height: 200))
            
            let imageData:NSData = UIImagePNGRepresentation(imagecropped)! as NSData
            
           // let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: NSData.Base64EncodingOptions.RawValue (0)))
            print(strBase64)
            
            imgBase64 = strBase64
            
            btnProfile.setImage(imagecropped, for: .normal)
            
            
            self.saveImageDocumentDirectory(_image: pickedImage, name: "\(NSUUID().uuidString).png")
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageDocumentDirectory(_image : UIImage,name : String)
    {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        
        imageSaved = name as NSString
        
        print(paths)
        let pngImageData = UIImagePNGRepresentation(_image)
        fileManager.createFile(atPath: paths as String, contents: pngImageData, attributes: nil)
    }
    
    func getImageFromDirectory(filename : String) -> UIImage
    {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(filename)
            let image    = UIImage(contentsOfFile: imageURL.path)
            
            if image != nil
            {
                return image!
            }
        }
        
        return UIImage(named:"UserProfile.png")!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize =   CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
            
            
        } else {
            newSize =  CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage
    {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let newImage: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return newImage
    }
    
    //MARK: TextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 11
        {
            
            return
        }
        else
        {
            
           
            
            var birthday = NSDate()
            let comps = NSDateComponents()
            
           // let calendar = Calendar.current
           // birthday = calendar.date(byAdding: .year, value: 5, to: birthday)

            
            birthday = birthday.addingTimeInterval(-(12.0 * 31556952.0))
            
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            datePickerView.setDate(birthday as Date, animated: true)
        }
        print("TextField did begin editing method called")
    }
    
    func handleDatePicker(sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtDOB.text = dateFormatter.string(from: sender.date)
    }
    
    func handleActionSheet(alert: UIAlertAction)
    {
        txtGender.text = alert.title!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
