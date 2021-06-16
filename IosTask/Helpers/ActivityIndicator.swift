//
//  ActivityIndicator.swift
//  BaseProject
//
//  Created by Pawan Dhull on 21/12/20.
//

import Foundation
import UIKit


//MARK: - LOADER (ACTIVITY indicator)
//CONTRIBUTED BY Pawan Dhull



let loadingView: UIView = UIView()
let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
var view1 = UIView()

func startAnimating(_ uiView : UIView){
        DispatchQueue.main.async {
        view1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view1.center = uiView.center
        view1.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view1.clipsToBounds = true
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view1.center
        loadingView.backgroundColor = UIColor.lightGray //you can set own color here
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        if #available(iOS 13.0, *) {
            actInd.style = UIActivityIndicatorView.Style.large
        } else {
            actInd.style = UIActivityIndicatorView.Style.whiteLarge
        }
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2)
        actInd.color = .blue
        loadingView.addSubview(actInd)
        view1.addSubview(loadingView)
        uiView.addSubview(view1)
        actInd.startAnimating()
    }
}

func stopAnimating(){
    DispatchQueue.main.async {
    actInd.stopAnimating()
    view1.removeFromSuperview()
    }
}

/*
 Usage :
 to start : startAnimating(yourView) //Most probably it is self.view for whole page
 to stop : stopAnimating()
 */



//MARK:- IMAGE LOADER
let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {

    var imageURL: URL?
    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL) {
        //setup activityIndicator...
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageURL = url
        image = nil
        activityIndicator.startAnimating()
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}



