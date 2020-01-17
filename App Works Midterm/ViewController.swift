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
    
    var headerImageView: UIImageView!
    
    var headerImageViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTableView.dataSource = self
        playlistTableView.delegate = self
        
        createTableViewHeader()
        
        playlistTableView.tableHeaderView = headerImageView
        
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

    func createTableViewHeader() {

        headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width))

        headerImageView.kf.setImage(with: URL(string: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg"))

        view.addSubview(headerImageView)
    }
    
//    func createTableViewHeader() {
//
//        headerImageView = UIImageView()
//        headerImageView.translatesAutoresizingMaskIntoConstraints = false
//
//        headerImageView.kf.setImage(with: URL(string: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg"))
//
//        view.addSubview(headerImageView)
//
//        headerImageViewTopConstraint = headerImageView.topAnchor.constraint(equalTo: view.topAnchor)
//
//        NSLayoutConstraint.activate([
//            headerImageViewTopConstraint,
//            headerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            headerImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor)
//        ])
//    }
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
        if let cell = cell as? PlaylistTableViewCell {
            let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                cell.alphaView.alpha = 0
            }
            animator.startAnimation()
        }
        
        if indexPath.row == playlists.count - 1 {
            if let max = maxPlaylists, playlists.count < max {
                getPlaylist()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? PlaylistTableViewCell {
            cell.alphaView.alpha = 0.9
        }
    }
}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset)
        
        if scrollView.contentOffset.y < 0 {
            
          
        }
    }
    
}
