//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer?

    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    let eggTimes: [String:Int] = [
        "Soft": 5,
        "Medium": 7,
        "Hard": 12
    ]
    
    var countDownTimer: Int? = nil
    
    var timer = Timer()
    
    @IBOutlet weak var eggHero: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        eggHero.text = sender.currentTitle
        
        let hardness = eggTimes[sender.currentTitle!]! //* 60
        
        var progress: Float = 0.00
        
        self.countDownTimer = hardness
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.countDownTimer! > 0 {
                progress += 1
                self.progressBar.progress = progress / Float( hardness)
                self.countDownTimer! -= 1
            } else {
                self.eggHero.text = "Your egg is ready!"
                self.playSound()
                self.timer.invalidate()
            }
        }
    }
    
}
