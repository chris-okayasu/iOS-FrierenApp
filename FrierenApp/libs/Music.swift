//
//  Music.swift
//  FrierenApp
//
//  Created by chris on 2024/10/15.
//

import AVKit

class SoundManager {
    
    static let shared = SoundManager() // Singleton -> only one instance of the entire app
    
    private var sfxPlayer: AVAudioPlayer?
    private var musicPlayer: AVAudioPlayer?
    private var audioPlayer: AVAudioPlayer?
    
    private init() {} // Now it is impossible to instance this clase because we want singleton 
    
    // Enum for short sounds
    enum SoundEffect: String {
        case flip = "page-flip"
        case error = "negative-beeps"
        case success = "magic-wand"
    }
    
    // MARK: private functions
    // Play song, mp3 as default
    private func playAudio(from path: String, loops: Int = 0) -> AVAudioPlayer? {
        let url = URL(filePath: path)
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.2
            player.numberOfLoops = loops // If playAudio(loop = -1) then Infinite loop
            player.play()
            return player
        } catch {
            print("Error al reproducir sonido: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Get the path and mimetype of the media
    private func playSound(named: String, ofType type: String = "mp3", loops: Int = 0) {
        if let path = Bundle.main.path(forResource: named, ofType: type) {
            sfxPlayer = playAudio(from: path, loops: loops)
        } else {
            print("No se encontró el archivo de sonido \(named).")
        }
    }
    
    // MARK: public functions
    func playFlipSound() {
        playSound(named: SoundEffect.flip.rawValue)
    }
    
    func playWrongSound() {
        playSound(named: SoundEffect.error.rawValue)
    }
    
    func playSuccessSound() {
        playSound(named: SoundEffect.success.rawValue)
    }
    
    func mainPageMusic() {
        playSound(named: "magic-in-the-air")
    }
    
    // infinite loop song
    func playMusic() {
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
        let randomSong = songs.randomElement() ?? "let-the-mystery-unfold"
        
        if let path = Bundle.main.path(forResource: randomSong, ofType: "mp3") {
            musicPlayer?.volume = 0.1
            musicPlayer = playAudio(from: path, loops: -1) // Infinite loop
        } else {
            print("No se encontró el archivo de música \(randomSong).")
        }
    }
    
}
