//
//  RegisterUserNameVC.swift
//  Login
//
//  Created by Jigar Patel on 27/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire

class RegisterUserNameVC: UIViewController, IQActionSheetPickerViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var txtCountryName: UITextField!
    @IBOutlet var txtCityName: UITextField!
    @IBOutlet var txtFName: UITextField!
    @IBOutlet var txtLName: UITextField!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var viewText: UIView!
    @IBOutlet var viewCountryText: UIView!
    
    let sharedObj = SharedClass()
    
    var arrCitiesGlobal = NSMutableArray()
    var arrCountriesGlobal = NSMutableArray()
    var arrCitiesIdGlobal = NSMutableArray()
    var arrCountryIdGlobal = NSMutableArray()
    
    var cityCode = ""
    var countryCode = ""
    
    var countryId = ""
    var countryName = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtFName.inputAccessoryView = toolbar
        self.txtLName.inputAccessoryView = toolbar
        
        
        
        txtFName.text = AppUtility.sharedInstance.getStringFromDefaults(key: "firstname")
        txtLName.text = AppUtility.sharedInstance.getStringFromDefaults(key: "lastname")
        
        //Get Country
        if let countryCodeGot = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCodeGot)
            
            let countryName = Locale.current.localizedString(forRegionCode: countryCodeGot)
            
            txtCountryName.text = countryName
            
            arrCitiesGlobal = getCities(countryName: txtCountryName.text!)
            arrCountriesGlobal = getCountries()
            
            print(arrCitiesGlobal)
            print(arrCountriesGlobal)
        }
        
        
        
        // Placeholder
        txtFName.attributedPlaceholder = NSAttributedString(string:"First Name", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        txtLName.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        txtCityName.attributedPlaceholder = NSAttributedString(string:"City Name", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        txtCountryName.attributedPlaceholder = NSAttributedString(string:"Country Name", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        
        tapGestureOnTextView()
        tapGestureOnCountryTextView()
        roundCornerButton()
        
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

    func tapGestureOnCountryTextView()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleCountryTap(sender:)))
        tap.delegate = self as UIGestureRecognizerDelegate
        self.viewCountryText.addGestureRecognizer(tap)
    }
    
    //MARK: - ActionSheet Functions
    var intervalActionSheet = UIAlertController()
    func HandleTap(sender: UITapGestureRecognizer? = nil)
    {
        intervalActionSheet = UIAlertController(title: "Select City:", message: "", preferredStyle: .actionSheet)
        
        for i in 0..<arrCitiesGlobal.count
        {
            intervalActionSheet.addAction(UIAlertAction(title: arrCitiesGlobal[i] as? String, style: UIAlertActionStyle.default, handler: handleActionSheet))
        }
        intervalActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        
        //CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.present(intervalActionSheet, animated: true, completion:nil)
        
    }
    
    //MARK: - ActionSheet Functions
    var intervalCountryActionSheet = UIAlertController()
    func HandleCountryTap(sender: UITapGestureRecognizer? = nil)
    {
        intervalCountryActionSheet = UIAlertController(title: "Select Country:", message: "", preferredStyle: .actionSheet)
        
        for i in 0..<arrCountriesGlobal.count
        {
            intervalCountryActionSheet.addAction(UIAlertAction(title: arrCountriesGlobal[i] as? String, style: UIAlertActionStyle.default, handler: handleCountryActionSheet))
        }
        intervalCountryActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        
        //CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.present(intervalCountryActionSheet, animated: true, completion:nil)
        
    }
    
    func handleActionSheet(alert: UIAlertAction)
    {
        txtCityName.text = alert.title!
        let index = intervalActionSheet.actions.index(of: alert)
        
        cityCode = arrCitiesIdGlobal[index!] as! String
        countryCode = arrCountryIdGlobal[index!] as! String
        
        
    }
    
    func handleCountryActionSheet(alert: UIAlertAction)
    {
        txtCountryName.text = alert.title!
        let index = intervalActionSheet.actions.index(of: alert)
        
       // countryCode = arrCountryIdGlobal[index!] as! String
        arrCitiesGlobal = getCities(countryName: txtCountryName.text!)
        
    }
    
    // MARK: - WebServiceCall
    
    func getCountries() -> NSMutableArray
    {
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        let arrCountries = NSMutableArray()
        
      //  let parameters = ["CountryName": countryName]
        let urlString = "http://dawati.net/api/dawati-get-all-countries"
        
        Alamofire.request(urlString, method: .get,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
            
            response in
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
                        
                        let arrCountry = dict.value(forKey: "responseData") as! NSArray
                        
                        for i in 0..<arrCountry.count
                        {
                            let dicCity = arrCountry[i] as! NSDictionary
                            let strCountry = dicCity.value(forKey: "CountryName")
                            let strCountryCode = dicCity.value(forKey: "Code")
                            let strCountryId = dicCity.value(forKey: "CountryID")
                            
                            self.arrCountryIdGlobal.add(strCountryId!)
                            
                            arrCountries.add(strCountry!)
                        }
                        
                        
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                Constant.sharedObj.alertView("Dawati", strMessage: "Login failed")
            }
        }
        
        return arrCountries
        
    }
    
    func getCities(countryName: String) -> NSMutableArray
    {
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        let arrCities = NSMutableArray()
        
        let parameters = ["CountryName": countryName]
        let urlString = "http://dawati.net/api/dawati-cities"
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
            
            response in
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
                        
                        let arrCity = dict.value(forKey: "responseData") as! NSArray
                        
                        for i in 0..<arrCity.count
                        {
                            let dicCity = arrCity[i] as! NSDictionary
                            let strCity = dicCity.value(forKey: "CityName")
                            let strCityCode = dicCity.value(forKey: "CityID")
                            let strCountryCode = dicCity.value(forKey: "CountryID")
                            
                            self.arrCitiesIdGlobal.add(strCityCode!)
                            self.arrCountryIdGlobal.add(strCountryCode!)
                            arrCities.add(strCity!)
                        }
                        
                        
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                Constant.sharedObj.alertView("Dawati", strMessage: "Login failed")
            }
        }
        
        return arrCities
        
    }
    
    // MARK: - UIButton Action
    
    @IBAction func btnNext(_ sender: Any)
    {
        
        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtFName.text!, key: "firstname")
        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtLName.text!, key: "lastname")
        
        //        txtFName.text = AppUtility.sharedInstance.getStringFromDefaults(key: "firstname")
        //        txtLName.text = AppUtility.sharedInstance.getStringFromDefaults(key: "lastname")
        validateAndNext()
    }
    
    // MARK: - Other Function
    
    func roundCornerButton(){
        self.btnNext.layer.cornerRadius = 5
    }
    
    // MARK: - Validate
    
    func validateAndNext()
    {
        if self.txtCityName.text! == "" || self.txtFName.text! == "" || self.txtLName.text == "" {
            Constant.alertView(Constant.alertmessage.Error, strMessage: "Please Enter First Name, Last Name and Country Name.")
        }
        else{
            
            AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtFName.text!, key: "firstname")
            AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtLName.text!, key: "lastname")
            
            let objRegisterProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterProfileVC") as! RegisterProfileVC
            objRegisterProfileVC.cityCode = cityCode
            objRegisterProfileVC.countryCode = countryCode
            
            self.navigationController?.pushViewController(objRegisterProfileVC, animated: true)
        }
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
