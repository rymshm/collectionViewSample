//
//  MainCollectionViewController.swift
//  collectionApp
//
//  Created by mashimac_w on 2017/05/15.
//  Copyright © 2017年 Ryo Mashima. All rights reserved.
//

import UIKit

import Alamofire

private let reuseIdentifier = "reuseIdentifier"

class MainCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var data: [Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                                                       withReuseIdentifier: "collectionHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        if let unwarpData = data as? [[AnyHashable: Any]] {
            return unwarpData.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.blue
    
        // Configure the cell
    
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    // MARK: SearchBar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let term: String = searchBar.text as String!, term != "" {
            
            let parameters: Parameters =  [ "q": term, "type": "album", "market": "jp", "limit": 50]
            
            Alamofire.request("https://api.spotify.com/v1/search", parameters: parameters).responseJSON(completionHandler: { response in
                
                if let jsonData: [AnyHashable: Any] = response.result.value as? [AnyHashable: Any] {
                    // parse
                    if let albums: [AnyHashable: Any] = jsonData["albums"] as? [AnyHashable: Any], let items: [[AnyHashable: Any]] = albums["items"] as? [[AnyHashable: Any]] {
                        self.data = items
                        self.collectionView?.reloadData()
                    }
                }
            })
        }
        
    }
    

}
