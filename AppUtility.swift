

import UIKit


class AppUtility
{
    static let sharedInstance = AppUtility()
    
    
    func saveStringToDefaults(StringtoStore :String,key: String)
    {
        UserDefaults.standard.set(StringtoStore, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getStringFromDefaults(key: String) -> String
    {
        var stringDefaults:String = ""
        if (UserDefaults.standard.object(forKey: key) != nil)
        {
            stringDefaults = UserDefaults.standard.value(forKey: key) as! String
        }
        return stringDefaults
    }
    func saveImageDocumentDirectory(_image : UIImage?,name : String)
    {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        
        print(paths)
        if _image != nil
        {
            let pngImageData = UIImagePNGRepresentation(_image!)
            fileManager.createFile(atPath: paths as String, contents: pngImageData, attributes: nil)
        }
        else
        {
            do {
                try fileManager.removeItem(atPath: paths)
                
            } catch let error as NSError {
                print("ERROR: \(error)")
            }
            
            //            do {
            //          try! fileManager.removeItem(atPath: paths as String)
            //            catch
            //            {
            //
            //            }
        }
        
    }
    func getImageFromDirectory(filename : String) -> UIImage?
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
            // Do whatever you want with the image
        }
        return nil
    }
}



