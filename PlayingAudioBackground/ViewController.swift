//
//  ViewController.swift
//  PlayingAudioBackground
//
//  Created by Nam (Nick) N. HUYNH on 3/23/16.
//  Copyright (c) 2016 Enclave. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?
    
    func handleInterruption(notification: NSNotification) {
        
        let interrupTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as NSNumber
        let interrupType = AVAudioSessionInterruptionType(rawValue: interrupTypeAsObject.unsignedLongValue)
        if let type = interrupType {
            
            if type == AVAudioSessionInterruptionType.Ended {
                
                // Ended - Resum if needed
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(dispatchQueue, { () -> Void in
            
            var audioSessionError: NSError?
            let audioSession = AVAudioSession.sharedInstance()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption:", name: AVAudioSessionInterruptionNotification, object: nil)
            audioSession.setActive(true, error: nil)
            
            if audioSession.setCategory(AVAudioSessionCategoryPlayback, error: &audioSessionError) {
                
                println("Successfully set the audio session!")
                
            } else {
                
                println("Could not set audio session!")
                
            }
            
            let filePath = NSBundle.mainBundle().pathForResource("MySong", ofType: "mp3")
            let fileData = NSData(contentsOfFile: filePath!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
            var error: NSError?
            self.audioPlayer = AVAudioPlayer(data: fileData, error: &error)
            if let theAudioPlayer = self.audioPlayer {
                
                theAudioPlayer.delegate = self
                if theAudioPlayer.prepareToPlay() && theAudioPlayer.play() {
                    
                    println("Successfully started playing!")
                    
                } else {
                    
                    println("Failed to play!")
                    
                }
                
            } else {
                
                // Failed
                
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

