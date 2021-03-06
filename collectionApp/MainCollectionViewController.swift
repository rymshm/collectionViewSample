//
//  MainCollectionViewController.swift
//  collectionApp
//
//  Created by mashimac_w on 2017/05/15.
//  Copyright © 2017年 Ryo Mashima. All rights reserved.
//

import UIKit
import AVFoundation

import Alamofire
import Kingfisher

private let reuseIdentifier = "reuseIdentifier"

class MainCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var responseData: [Any]?
    
    var player: AVQueuePlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let nib: UINib = UINib.init(nibName: "AlbumCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        
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
        
        if let responseData = responseData as? [[AnyHashable: Any]] {
            return responseData.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as? AlbumCollectionViewCell {
            
            if let albumInfo = responseData?[indexPath.row] as? [AnyHashable: Any] {
                
                // Artwork
                if let images = albumInfo["images"] as? [Any], let image = images[1] as? [AnyHashable: Any], let imageUrl = image["url"] as? String {
                    cell.artworkImageView.kf.setImage(with: URL(string: imageUrl))
                }
                // Album info 
                if let albumName = albumInfo["name"] as? String, let albumId = albumInfo["id"] as? String {
                    cell.albumNameLabel.text = albumName
                    cell.albumId = albumId
                }
            }
           
            return cell
        }
    
        return UICollectionViewCell.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
            
            // Fetch Tracks
            if let albumId = cell.albumId {
                Alamofire.request("https://api.spotify.com/v1/albums/" + albumId).responseJSON(completionHandler: { response in
                    // get JSON
                    if let jsonDictionary = response.result.value as? [AnyHashable: Any] {
                        // parse
                        if let tracks = jsonDictionary["tracks"] as? [AnyHashable: Any], let items = tracks["items"] as? [Any] {
                            
                            var trackList = [AVPlayerItem]()
                            
                            for track in items {
                                if let track = track as? [AnyHashable: Any], let previewUrl = track["preview_url"] as? String, let url = URL.init(string: previewUrl) {
                                    let playerItem = AVPlayerItem.init(url: url)
                                    trackList.append(playerItem)
                                }
                            }
                            
                            // Play
                            self.player = AVQueuePlayer.init(items: trackList)
                            if let player = self.player {
                                player.play()
                            }
                        }
                    }
                })
            }
        }
        
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
            
            let parameters: Parameters =  ["q": term, "type": "album", "market": "jp", "limit": 30]
            
            Alamofire.request("https://api.spotify.com/v1/search", parameters: parameters).responseJSON(completionHandler: { response in
                
                if let jsonData = response.result.value as? [AnyHashable: Any] {
                    // parse
                    if let albums = jsonData["albums"] as? [AnyHashable: Any], let items = albums["items"] as? [[AnyHashable: Any]] {
                        self.responseData = items
                        self.collectionView?.reloadData()
                    }
                }
            })
        }
    }
    

}
