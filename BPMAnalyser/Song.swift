//
//  Song.swift
//  BPMAnalyser
//
//  Created by John Baer on 7/15/20.
//  Copyright © 2020 Gleb Karpushkin. All rights reserved.
//

import Foundation

struct Song {
    var title: String = ""
    var BPM: Float = 0
    var played: Bool = false
    
    init(title: String, BPM: Float, played: Bool) {
        self.title = title
        self.BPM = BPM
        self.played  = played
    }
}
