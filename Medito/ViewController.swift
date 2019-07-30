//
//  ViewController.swift
//  Medito
//
//  Created by Deekshith Maram on 7/29/19.
//  Copyright © 2019 Deekshith Maram. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()

    @IBOutlet weak var maxTimeLbl: UILabel!
    @IBOutlet weak var minTimeLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    
    var status = 0
    
    @IBAction func play(_ sender: Any) {
        if(status == 0){
            self.playAudio()
            self.status = 1
            self.playBtn.setImage(UIImage(named: "rounded-pause-button.png"), for: .normal)
        }else{
            self.pauseAudio()
               self.status = 0
               self.playBtn.setImage(UIImage(named: "play-button.png"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setSession()
        
         coverImg.layer.shadowColor = UIColor.gray.cgColor
         coverImg.layer.shadowOpacity = 2.0
         coverImg.layer.shadowOffset = CGSize.zero
         coverImg.layer.shadowRadius = 20
         coverImg.layer.masksToBounds = false
         coverImg.layer.cornerRadius = 15
        self.timeSlider.setThumbImage(UIImage(named: "slider-circle.png")!, for: .normal)
        
        var Time = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeSlider), userInfo: nil, repeats: true)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        do {
            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
            try
                player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        
        }catch{
            print(error,"Errorr")
        }
       
          self.timeSlider.maximumValue = Float(player.duration)
          self.volumeSlider.maximumValue = Float(player.volume)
          self.volumeSlider.value = self.volumeSlider.maximumValue
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: player.duration)!
        self.maxTimeLbl.text =  formattedString
        self.minTimeLbl.text = "0:00"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .full
        
        self.minTimeLbl.text = formatter.string(from: player.currentTime)
    }
    
 
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    func pauseAudio(){
        player.pause()
    }
    
    func playAudio(){
        player.play()
    }
    
    func setSession(){
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch{
            print(error)
        }
    }
    
   @objc func updateTimeSlider(){
    self.timeSlider.value = Float(player.currentTime)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    
     let formattedString = formatter.string(from: player.currentTime)!
        self.minTimeLbl.text = formattedString
    }
    
    @IBAction func changePlayerVolume(_ sender: Any) {
        self.player.volume = volumeSlider.value
    }
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (hr, min, 60 * secf)
    }
    
    @IBAction func changeAudioTime(_ sender: Any) {
        self.status = 1
        self.playBtn.setImage(UIImage(named: "rounded-pause-button.png"), for: .normal)
        player.stop()
        player.currentTime = TimeInterval(timeSlider.value)
        player.prepareToPlay()
        player.play()
    }
    
    
    //    override func remoteControlReceived(with event: UIEvent?) {
//        if event!.type == UIEvent.EventSubtype.RemoteControlPause{
//            print("pause")
//            player.pause()
//        }else if event!.type == UIEvent.EventSubtype.remoteControlPlay{
//            print("playing")
//            player.play()
//        }
//    }
//    

}

