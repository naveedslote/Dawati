//
//  AboutVC.swift
//  Login
//
//  Created by Admin on 03/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class MisionVisionVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /*
         http://dawati.net/beta/page/en/mission-vision-mobile (Missaion & Vission)
        http://dawati.net/beta/page/en/salient-features-for-business-mobile (Salient Features For Business)
        http://dawati.net/beta/page/en/salient-features-for-consumers-mobile (Salient Features For Consumer)
        http://dawati.net/beta/page/en/corporate-information-mobile (Corporate Information)
        http://dawati.net/beta/page/en/about-us-mobile (About Dawati)
        
         http://dawati.net/beta/page/en/neighborhood-in-islam-mobile (Neighborhood in Islam)
        http://dawati.net/beta/page/en/about-7th-neighbor-mobile (About 7th Neighbors)
         
        http://dawati.net/beta/page/en/terms-and-conditions-mobile (Terms and Conditions)
        http://dawati.net/beta/page/en/faq-mobile (FAQ)
        http://dawati.net/beta/page/en/our-motto-mobile (Our Motto)
         */
        
        let webPage = UserDefaults.standard.object(forKey: "webPage") as? String
        // Do any additional setup after loading the view.
        var webUrl : NSURL = NSURL(string: "http://dawati.net/beta/page/en/mission-vision-mobile")!
        
        if (webPage == "CorpInfo")
        {
           webUrl = NSURL(string: "http://dawati.net/beta/page/en/corporate-information-mobile")!
        }
        else if (webPage == "AboutDawati")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/about-us-mobile")!
        }
        else if (webPage == "BussSalientFeatures")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/salient-features-for-business-mobile")!
        }
        else if (webPage == "ConsSalientFeatures")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/salient-features-for-consumers-mobile")!
        }
        else if (webPage == "MissViss")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/mission-vision-mobile")!
        }
        else if (webPage == "SevthNeighbour")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/about-7th-neighbor-mobile")!
        }
        else if (webPage == "NeighbourhoodInIslamSalientFeatures")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/neighborhood-in-islam-mobile")!
        }
        else if (webPage == "TermsAndConditions")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/terms-and-conditions-mobile")!
        }
        else if (webPage == "FAQ")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/faq-mobile")!
        }
        else if (webPage == "OurMotto")
        {
            webUrl = NSURL(string: "http://dawati.net/beta/page/en/our-motto-mobile")!
        }
        
        let webRequest : NSURLRequest = NSURLRequest(url: webUrl as URL)
        webView.loadRequest(webRequest as URLRequest)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Strat Loading")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finish Loading")
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription )
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
}

