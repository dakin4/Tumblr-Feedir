//
//  UserViewController.swift
//  Tumblr Feedir
//
//  Created by David King on 2/2/18.
//  Copyright © 2018 David King. All rights reserved.
//

import UIKit
import AlamofireImage
//protocal very similar to an abstract class in java ie there are functions that must be implemented in code
class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableview: UITableView!
    
    
    var posts: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self

        apigrab()
        
        // Do any additional setup after loading the view.
    }
    
    
    func apigrab () {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                //stores the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                //print(self.posts)
                // TODO: Get the posts and store in posts property 
                
                // TODO: Reload the table view
               self.tableview.reloadData()
            }
        }
        task.resume()
     
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "tumblrcell", for: indexPath) as! tumblrcell
        
        let post = posts[indexPath.row]
        
       if let photos = post ["photos"] as? [[String: Any]] {
            
           let photo = photos [0]
            
            let originalSize = photo["original_size"] as! [String: Any]
            
            let urlString = originalSize["url"] as! String
            
            let url = URL(string: urlString)
            
            cell.tumblrImage.af_setImage(withURL: url!)
            
    
        }
        
        
       
        
        return cell
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        
        if let indexPath = tableview.indexPath(for: cell)
        {
            let post = posts[indexPath.row]
            
            var photos = post ["photos"] as! [[String: Any]]
            
            let photo = photos[0]
            
            let originalsize = photo["original_size"] as! [String: Any]
            
            let urlString = originalsize["url"] as! String
            
            let url = URL(string: urlString)
        
            
            let pho = segue.destination as! PhotoDetailsViewController
            
            pho.url = url
         // photos.photoView.af_setImage(withURL: url!)
            

            
            
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
