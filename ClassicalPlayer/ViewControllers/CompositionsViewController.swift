//
//  CompositionsViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/7/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit

class CompositionsViewController: UITableViewController {

    let networkManager = NetworkManager()

    var compositions = [Video]()

    var composer: Composer? {
        didSet {
            networkManager.loadVideos(request: composer!.name) {  [weak self] (videos, error) in
                if let videos = videos {
                    self?.compositions = videos
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let video = compositions[tableView.indexPathForSelectedRow!.row]
        (segue.destination as! PlaybackViewController).videoId = video.videoId
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compositions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CompositionCell", for: indexPath) as! CompositionCell

        let video = compositions[indexPath.row]

        cell.nameLabel.text = video.title
        
        return cell
    }

}
