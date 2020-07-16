
//
//  ViewController.swift
//  BPMAnalyser
//
//  Created by Gleb Karpushkin on 29/03/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//



//Have to get the parsing function from Michael to get the song's actual BPMs

import UIKit
import MediaPlayer
import AVKit

var SongsArr: [Song] = []

//FiRST PAGE ~
//struct Song {
//    var title: String = ""
//    var BPM: Float = 0
//    var played: Bool = false
//
//    init(title: String, BPM: Float, played: Bool) {
//        self.title = title
//        self.BPM = BPM
//        self.played  = played
//    }
//}
//~ FiRST PAGE



let fm = FileManager.default
let filePath = Bundle.main.path(forAuxiliaryExecutable: "Songs")
let songs = try! fm.contentsOfDirectory(atPath: filePath!)


class ViewController: UIViewController {
    var paused = true
    var currentSong: Song? = nil
    var currentSongIndex: Int? = nil
    var previousSongs: [Song] = []
    let audioPlayer = AVAudioPlayerNode()
    
    
    
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()

    let engineBPM = AVAudioEngine()
    let speedControlBPM = AVAudioUnitVarispeed()
    let pitchControlBPM = AVAudioUnitTimePitch()
    
    var speedOfBPM:Float = 0.0
    
    
    let mediaPicker: MPMediaPickerController = MPMediaPickerController(mediaTypes: .music)
    
    @IBAction func playPauseClicked(_ sender: Any) {
        paused = !paused
        
        if !paused{
            if currentSong == nil{
                //find a song to play, currently just the first song in the BPMArr
                currentSong = SongsArr[0]
                currentSongIndex = 0
                SongsArr[0].played = true
                let filePathSong = Bundle.main.path(forResource: removeSuffix(songName: currentSong!.title), ofType: "mp3", inDirectory: "Songs")
                let songUrl = URL(string: filePathSong!)
//                let BPMOfSong = BPMAnalyzer.core.getBpmFrom(songUrl!, completion: nil)
                do { try play(songUrl!)
                }catch{}
            }else{
                audioPlayer.play()
            }
        }else{
            audioPlayer.pause()
        }
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        previousSongs.append(currentSong!)
        //No more songs!
        if currentSongIndex == SongsArr.count-1{
            for i in 0...SongsArr.count-1{
                SongsArr[i].played = false
            }
            currentSong = SongsArr[0]
            currentSongIndex = 0
        }else{
            currentSongIndex! += 1
            currentSong = SongsArr[currentSongIndex!]
            let filePathSong = Bundle.main.path(forResource: removeSuffix(songName: currentSong!.title), ofType: "mp3", inDirectory: "Songs")
            let songUrl = URL(string: filePathSong!)
//                let BPMOfSong = BPMAnalyzer.core.getBpmFrom(songUrl!, completion: nil)
            do { try play(songUrl!)
            }catch{}
        }
    }
    
    @IBAction func prevClicked(_ sender: Any) {
        if previousSongs.count == 0{
            currentSongIndex! = 0
            currentSong = SongsArr[currentSongIndex!]
        }else{
            currentSongIndex! -= 1
            currentSong = previousSongs.popLast()
        }
        let filePathSong = Bundle.main.path(forResource: removeSuffix(songName: currentSong!.title), ofType: "mp3", inDirectory: "Songs")
        let songUrl = URL(string: filePathSong!)
//                let BPMOfSong = BPMAnalyzer.core.getBpmFrom(songUrl!, completion: nil)
        do { try play(songUrl!)
        }catch{}
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaPicker.allowsPickingMultipleItems = false
        mediaPicker.delegate = self
        present(mediaPicker, animated: true, completion: nil)
        
        
        //FiRST PAGE ~
        for song in songs{
            let filePathSong = Bundle.main.path(forResource: removeSuffix(songName: song), ofType: "mp3", inDirectory: "Songs")
            let songUrl = URL(string: filePathSong!)
            let BPMOfSongString = BPMAnalyzer.core.getBpmFrom(songUrl!, completion: nil)
            let BPMOfSong = convertBPMToFloat(BPMOfSongString)
            let newSong = Song(title: removeSuffix(songName: song), BPM: BPMOfSong, played: false)
            SongsArr.append(newSong)
        }
        
        //~ FiRST PAGE
        
    }
    
    func play(_ url: URL) throws {
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)
        
        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleFile(file, at: nil)
        
        // 6: start the engine and player
        try engine.start()
        audioPlayer.play()
    }
    
    
    //FiRST PAGE ~
    func removeSuffix(songName: String) -> String{
        var output = ""
        for letter in songName{
            if letter != "."{
                output += String(letter)
            }else{
                break
            }
        }
        return output
    }
    
    func convertBPMToFloat(_ bpmString: String) -> Float {
        // Really dirty way to parse the string return form BPMAnalyzer
        // Definitely a better way to do this
        let bpmSplitArray = bpmString.components(separatedBy: " ")
        let splitBPMSpaces = bpmSplitArray[2]
        let splitBPMComma = splitBPMSpaces.components(separatedBy: ",")
        let toBeConvertedFromString = splitBPMComma[0]
        let bpmFloat = Float(toBeConvertedFromString)

        return bpmFloat!
    }
    //~ FiRST PAGE
}



extension ViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems
        mediaItemCollection: MPMediaItemCollection) {
        guard let asset = mediaItemCollection.items.first,
            let url = asset.assetURL else {return}
        _ = BPMAnalyzer.core.getBpmFrom(url, completion: {[weak self] (bpm) in
            self?.mediaPicker.dismiss(animated: true, completion: nil)
        })
    }
}

