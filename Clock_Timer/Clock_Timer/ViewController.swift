//
//  ViewController.swift
//  Clock_Timer
//
//  Created by Cullen Vaughan on 2/5/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var TimeRemaining: UILabel!
    @IBOutlet weak var DateTime: UILabel!
    @IBOutlet weak var StartStopButton: UIButton!
    
    var Spped : Float = 1.0
    var timeLeft : Int?
    var estimatedTime : Int?
    var clockTimer: Timer = Timer()
    var countdownTimer: Timer = Timer()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        DateTime.text = formatter.string(from: Date())
        formatter.dateFormat = "a"
        StartStopButton.setTitle("Start Timer", for: .normal)
        StartStopButton.configuration?.baseForegroundColor = UIColor.black

        DatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        TimeRemaining.text = "Time Remaining:"
        
        getCurrentTime()
    }

    private func getCurrentTime() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        DateTime.text = formatter.string(from: Date())

        formatter.dateFormat = "a"
    }
    
    func Time(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func printTime(_ seconds: Int) -> String {
        let (h, m, s) = Time(seconds)
        return String(format: "%02d:%02d:%02d",h,m,s)
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        countdownTimer.invalidate()
        if (StartStopButton.currentTitle == "Start Timer") {
            StartStopButton.setTitle("Stop Music", for: .normal)
            timeLeft = Int(DatePicker.countDownDuration)
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            TimeRemaining.text = "Time Remaining: \(printTime(Int(DatePicker.countDownDuration)))"
        } else {
            player?.stop()
            StartStopButton.setTitle("Start Timer", for: .normal)
        }
    }
    
    @objc func startCountDown() {
        if timeLeft! >= 0 {
            TimeRemaining.text = "Time Remaining: \(printTime(timeLeft!))"
            timeLeft! -= 1
        } else {
            countdownTimer.invalidate()
            playMusic()
        }
    }
    
    func playMusic() {
        if let asset = NSDataAsset(name:"MER"){
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
