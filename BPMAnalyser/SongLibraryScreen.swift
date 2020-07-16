//
//  SongLibraryScreen.swift
//  BPMAnalyser
//
//  Created by John Baer on 7/15/20.
//  Copyright © 2020 Gleb Karpushkin. All rights reserved.
//

import UIKit

class SongLibraryScreen: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}



extension SongLibraryScreen: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return SongsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let songCell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
        return songCell
    }
}
