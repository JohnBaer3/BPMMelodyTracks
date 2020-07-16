//
//  SongCell.swift
//  BPMAnalyser
//
//  Created by John Baer on 7/15/20.
//  Copyright © 2020 Gleb Karpushkin. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell{
    @IBOutlet weak var songCellTitle: UILabel!
    @IBOutlet weak var songCellArtist: UILabel!
    
    func setCell(song: Song){
        self.songCellTitle.text = song.title
        self.songCellArtist.text = "The Black Eyed Peas"
    }
}
