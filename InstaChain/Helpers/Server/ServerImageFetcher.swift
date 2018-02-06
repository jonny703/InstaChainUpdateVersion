//
//  ImageFetcher.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit
import AlamofireImage


class ServerImageFetcher {
    
    static let i = ServerImageFetcher()
    
    fileprivate init(){
        
    }
    
    func loadImageIn(_ iv :UIImageView, url :String){
        if let nSUrl = URL(string: validateUrl(url)){
            let indicator = getAndAddIndicator(iv)
            
            
            iv.af_setImage(withURL: nSUrl, placeholderImage: nil,filter:nil,imageTransition: .crossDissolve(0.3),runImageTransitionIfCached: false,
                completion: { (response) -> Void in
                    indicator.removeFromSuperview()
            })
        }
    }
    
    func loadImageIn(_ iv :UIImageView, url :String, placeHolder :String){

        if let nSUrl = URL(string: validateUrl(url)){
            if let placeholderImage = UIImage(named: placeHolder) {
                let indicator = getAndAddIndicator(iv)
                iv.af_setImage(withURL:nSUrl, placeholderImage: placeholderImage,filter:nil,imageTransition: .crossDissolve(0.3),runImageTransitionIfCached: false,
                    completion: { (response) -> Void in
                        indicator.removeFromSuperview()
                })
            }
            else{
                loadImageIn(iv, url: url)
            }

        }
        else{
            print("unable to convert proper url  \(url)")
        }
    }
    
    func loadImageWithDefaultsIn(_ iv :UIImageView, url :String){
        
        if let nSUrl = URL(string: validateUrl(url)){
            let indicator = getAndAddIndicator(iv)
            iv.af_setImage(withURL:nSUrl, placeholderImage: nil,filter:AspectScaledToFillSizeFilter(size: getValidFrameSize(iv.frame.size)),imageTransition: .crossDissolve(0.3),runImageTransitionIfCached: false,
                completion: { (response) -> Void in
                indicator.removeFromSuperview()
            })
        }
        else {
            print("unable to convert proper url  \(url)")
            iv.image = UIImage(named: "Issue")
        }
    }

    func loadProfileImageIn(_ iv :UIImageView, url :String){

        if let nSUrl = URL(string: validateUrl(url)){
            let indicator = getAndAddIndicator(iv)

            iv.af_setImage(withURL:nSUrl, placeholderImage: UIImage(),filter:nil,imageTransition: .crossDissolve(0.3),runImageTransitionIfCached: false,
                           completion: { (response) -> Void in
                            indicator.removeFromSuperview()
                            iv.layer.cornerRadius = iv.frame.size.width / 2;
                            iv.clipsToBounds = true;
            })

        }
        else{
            print("unable to convert proper url  \(url)")
            iv.image = UIImage(named: "Issue")
            
        }
    }

    
    func loadProfileImageWithDefaultsIn(_ iv :UIImageView, url :String){
        
        if let nSUrl = URL(string: validateUrl(url)){
            let indicator = getAndAddIndicator(iv)

            iv.af_setImage(withURL:nSUrl, placeholderImage: UIImage(),filter:AspectScaledToFitSizeFilter(size: iv.frame.size),imageTransition: .crossDissolve(0.3),runImageTransitionIfCached: false,
                completion: { (response) -> Void in
                    indicator.removeFromSuperview()
                    
                    iv.layer.cornerRadius = iv.frame.size.width / 2;
                    iv.clipsToBounds = true;
            })

        }
        else{
            print("unable to convert proper url  \(url)")
            iv.image = UIImage(named: "Issue")

        }
    }
    
    func validateUrl(_ url : String) ->String {
        if !url.contains("http"){
            return "http://\(url)"
        }
        return url
    }
    
    
    func getAndAddIndicator(_ imageView :UIImageView) -> UIActivityIndicatorView {
        
        if let v = imageView.viewWithTag(43539) as? UIActivityIndicatorView {
            return v
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.tag = 43539
        indicator.center = imageView.center
        indicator.startAnimating()
        imageView.addSubview(indicator)
        imageView.pinViewToCenter(indicator)
        
        return indicator
    }
    
    func getValidFrameSize(_ size: CGSize) -> CGSize{
        
        return CGSize( width: max(size.width, 1), height: max(size.height,1))
    }
    
}
