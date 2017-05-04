//
//  ViewController.swift
//  Flicker_API_Image_Download
//
//  Created by Apple on 25/05/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    
    var arrayTableData : NSMutableArray!
    var mydic : NSDictionary = [:]
    var newdic : NSDictionary = [:]
    
    
    var farm = NSString()
    var id = NSString()
    var secret = NSString()
    var server = NSString()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        arrayTableData = []
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    @IBAction func buttonActionShowImage(_ sender: AnyObject) {
        
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b7b53305065c52ef03c9eedf7a6b3362&text=usa+festival&format=json&nojsoncallback=1&api_sig=f78b8d0e48ef58ffcb9e892629d3ce17"
        
        urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL (string:urlString)
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = "POST"
        let sessionconfig = URLSessionConfiguration.default
        let session = URLSession (configuration: sessionconfig)
        
        let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) in
//                guard let _:NSData = data, let _:NSURLResponse = response where error == nil else
//                {
//                    print(response)
//                    
//                }
                
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8)
                print("Output: '\(datastring!)'")
                
                do{
                    self.mydic = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    print(self.mydic)
                    [self.mydic .object(forKey: "photos")]
                    //Sucess
                }
                catch
                {
                    //failer
                    print("Fetch Failed: \((error as NSError).localizedDescription)")
                }
                
                let newarray = (self.mydic as NSDictionary).object(forKey: "photos")?.object(forKey: "photo") as! [[String:AnyObject]]
                print(newarray)
                
                for (index)in newarray
                {
                    let diction: NSDictionary = index as AnyObject as! NSDictionary
                    print(index)
                    print(diction)
                    
                    let str = NSString(format:"https://farm\(diction .value(forKey: "farm")!).staticflickr.com/\(diction .value(forKey: "server")!)/\(diction .value(forKey: "id")!)_\(diction .value(forKey: "secret")!)_m.jpg")
                    
                    str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
                    self.arrayTableData.add(str)
                    print("output '\(self.arrayTableData)'")
                    
                }
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                    
                })
                
                
                
                
        })            

        
        
        task.resume()
        
        
        
    }
   
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MyCollectionViewCell
        
        
        
        let imageURL = arrayTableData.object(at: indexPath.row) as! String
        let data = try? Data(contentsOf: (URL(string: imageURL))!)
        let img = UIImage(data: data!)
        
        cell?.imageView!.image=img
        
        return cell!
    }
}

