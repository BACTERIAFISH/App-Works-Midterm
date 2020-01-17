//
//  ViewController.swift
//  App Works Midterm
//
//  Created by FISH on 2020/1/17.
//  Copyright © 2020 FISH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    let userProvider = UserProvider()
    
    let playlistProvider = PlaylistProvider()
    
    var playlists = [Playlist]()
    
    var isLoading = false
    
    var maxPlaylists: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTableView.dataSource = self
        playlistTableView.delegate = self
        
        playlistTableView.tableHeaderView = createTableViewHeader()
        
        userProvider.getToken()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getPlaylist), name: NSNotification.Name("getToken"), object: nil)
    }
    
    @objc func getPlaylist() {
        if !isLoading {
            isLoading = true
            playlistProvider.getPlaylist(offset: playlists.count) { [weak self] (result) in
                switch result {
                case .success(let playlistData):
                    self?.playlists += playlistData.data
                    self?.playlistTableView.reloadData()
                    if self?.maxPlaylists == nil {
                        self?.maxPlaylists = playlistData.summary.total
                    }
                    self?.isLoading = false
                case .failure(let error):
                    print("get playlist error: \(error)")
                    self?.isLoading = false
                }
            }
        }
    }

    func createTableViewHeader() -> UIImageView {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))
        
        imageView.kf.setImage(with: URL(string: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg"))
        
        view.addSubview(imageView)
        
        return imageView
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistTableViewCell", for: indexPath) as? PlaylistTableViewCell else { return UITableViewCell() }
        
        cell.playlist = playlists[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == playlists.count - 1 {
            if let max = maxPlaylists, playlists.count < max {
                getPlaylist()
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        print("2222")
//    }
}
