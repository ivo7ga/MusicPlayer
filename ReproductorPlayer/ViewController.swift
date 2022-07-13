//
//  ViewController.swift
//  ReproductorPlayer
//
//  Created by Iván González on 24/2/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var previous: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var barrita: UISlider!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondLast: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    let songs = ["DingDong", "LoveAgain", "IFeelInLoveWhitTheDevil", "LeadTheWay", "TheShowMustGoOn"]
    let titulos = ["Gunther", "Dua Lipa", "Avril Lavigne", "Carlos Jean", "Queen"]
    let image1 = UIImage(imageLiteralResourceName: "Album1")
    let image2 = UIImage(imageLiteralResourceName: "Album2")
    let image3 = UIImage(imageLiteralResourceName: "Album3")
    let image4 = UIImage(imageLiteralResourceName: "Album4")
    let image5 = UIImage(imageLiteralResourceName: "Album5")
    var images = [UIImage]()
    
    var player = AVAudioPlayer()
    var index = 0
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images = [image1, image2, image3, image4, image5]
        setup()
        
    }
    
    func setup(){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index], ofType: "mp3")!)
        player = try! AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        myImageView.image = images[index]
        nameLabel.text = songs[index]
        groupLabel.text = titulos[index]
        secondLast.isHidden = true
    }
    
    @objc func slider(){
        barrita.maximumValue = Float(player.duration)
        barrita.value = Float(player.currentTime)
        let remaining = player.duration - player.currentTime
        secondLast.isHidden = false
        secondLast.text = getFormattedTime(timeInterval: remaining)
    }
    
    
    @IBAction func play(_ sender: UIButton) {
        if player.isPlaying{
            player.pause()
            play.setImage(UIImage(systemName: "play.fill"), for: .normal)
            nameLabel.text = songs[index]
            groupLabel.text = titulos[index]
        }else{
            player.play()
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(slider), userInfo: nil, repeats: true)
            play.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            nameLabel.text = songs[index]
            groupLabel.text = titulos[index]
        }
    }
    
    @IBAction func controlSlider(_ sender: UISlider) {
        player.pause()
        player.currentTime = TimeInterval(sender.value)
        player.play()
    }
    @IBAction func previous(_ sender: UIButton) {
        if player.isPlaying{
            if (index <= 4) && (index > 0){
                myImageView.image = images[index - 1]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index - 1], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
                player.play()
                play.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                index = index - 1
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
            }else {
                player.play()
                play.setImage(UIImage(systemName: "play.fill"), for: .normal)
                index = 4
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
                myImageView.image = images[index]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
            }
        }else {
            if (index <= 4) && (index > 0){
                myImageView.image = images[index - 1]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index - 1], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
                player.pause()
                play.setImage(UIImage(systemName: "play.fill"), for: .normal)
                index = index - 1
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
            }else {
                player.pause()
                play.setImage(UIImage(systemName: "play.fill"), for: .normal)
                index = 4
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
                myImageView.image = images[index]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
            }
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        nextSong()
    }
    func getFormattedTime(timeInterval: TimeInterval) ->  String{
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secStr =
                timeFormatter.string(from: NSNumber(value: secs)) else{
                    return "00:00"
                }
        return "\(minsString): \(secStr)"
    }
    func nextSong(){
        if player.isPlaying{
            if ((index < 4) && (index >= 0)){
                myImageView.image = images[index + 1]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index + 1], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
                player.play()
                play.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                index = index + 1
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
            }else{
                player.play()
                play.setImage(UIImage(systemName: "play.fill"), for: .normal)
                index = 0
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
                myImageView.image = images[index]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
            }
        }else {
            if ((index < 4) && (index >= 0)){
                myImageView.image = images[index + 1]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index + 1], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
                player.pause()
                play.setImage(UIImage(systemName: "play.fill"), for: .normal)
                index = index + 1
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
            }else{
                player.pause()
                play.setImage(UIImage(systemName: "play.fill"), for: .normal)
                index = 0
                nameLabel.text = songs[index]
                groupLabel.text = titulos[index]
                myImageView.image = images[index]
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: songs[index], ofType: "mp3")!)
                player = try! AVAudioPlayer(contentsOf: url)
            }
        }
    }
       
}


