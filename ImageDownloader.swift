//
//  ImageDownloader.swift
//  BaseProject
//
//  Created by Hardik Hadwani on 19/06/18.
//  Copyright © 2018 Hardik Hadwani. All rights reserved.
//
typealias ImageDownloaded = ((UIImage) -> ())

import Foundation
import UIKit
class ImageDownloader {
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var imagesBeingDownloaded: [String] = [String]()
    var noImages: [String] = [String]()

    var cache: NSCache<NSString, UIImage>!
    
    init() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
    }
    func downloadImageForPath(imgPath: String, completionHandler: @escaping ImageDownloaded) {
        let imgName = (imgPath as NSString).lastPathComponent
        if let image = self.getImage(name: imgName){//cache.object(forKey: imgPath as NSString) {
            DispatchQueue.main.async {
                //If cached image available than return that image.
                print("Image loaded from cache for path : \(imgPath)")
                completionHandler(image)
            }
        }
        else
        {
            if(!noImages.contains(imgPath)){
                let url: URL! = URL(string: imgPath)
                print("Start Image downloading for path : \(imgPath)");
                imagesBeingDownloaded.append(imgPath)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                    if let data = try? Data(contentsOf: url) {
                        print("Image downloaded for path : \(imgPath)");
                        self.imagesBeingDownloaded.remove(at: self.imagesBeingDownloaded.index(of: imgPath)!)
                        let img: UIImage! = UIImage(data: data)
                        self.saveImageDocumentDirectory(name: imgName, imageData: data)
                      //  self.cache.setObject(img, forKey: imgPath as NSString)
                        DispatchQueue.main.async {
                            completionHandler(img)
                        }
                    }
                    else{
                        self.imagesBeingDownloaded.remove(at: self.imagesBeingDownloaded.index(of: imgPath)!)
                        self.noImages.append(imgPath)
                        DispatchQueue.main.async {
                            // You need placeholder image in your assets so that if image download fail this will be displayed
                            let placeholder = #imageLiteral(resourceName: "coin")
                            completionHandler(placeholder)
                        }
                    }
                })
                task.resume()
            }
            else
            {
                let placeholder = #imageLiteral(resourceName: "coin")
                completionHandler(placeholder)
            }
        }
    }

    func saveImageDocumentDirectory(name : String,imageData : Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
       // let imageData = UIImageJPEGRepresentation(image, 1.0)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func getImage(name : String) -> UIImage?{
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("No Image")
        }
        return nil
    }
}
