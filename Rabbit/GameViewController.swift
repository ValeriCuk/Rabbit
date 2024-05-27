import UIKit
import SpriteKit
import GameplayKit
import SnapKit
import AVFoundation

class GameViewController: UIViewController {
    
    private let skView = SKView()
    private var gameScene = GameScene()
    private var testGS = MenuGameScene()
    private var soundImageView = UIImageView()
    private var menuMusicPlayer: AVAudioPlayer?
    private var gameMusicPlayer: AVAudioPlayer?
    var soundOn = true {
        willSet{
            isPlayingPlayers(newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameScene = GameScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        testGS = MenuGameScene(size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        setSKViewAppiriance()
        playMenuMusic()
        addSoundImageVeiw()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setSKViewAppiriance() {
        skView.backgroundColor = .clear
        view.addSubview(skView)
        skView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        skView.presentScene(testGS)
    }
    
    private func addSoundImageVeiw() {
        soundImageView.image = UIImage(named: "soundOn")
        soundImageView.isUserInteractionEnabled = true
        soundImageView.alpha = 0.9
        view.addSubview(soundImageView)
        soundImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            $0.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.1)
            $0.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.08)
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        soundImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.animateImageView {
            switch self.soundImageView.image {
            case UIImage(named: "soundOn"):
                self.soundImageView.image = UIImage(named: "soundOff")
                self.soundOn = false
            case UIImage(named: "soundOff"):
                self.soundImageView.image = UIImage(named: "soundOn")
                self.soundOn = true
            default:
                break
            }
        }
    }
    
    private func isPlayingPlayers(_ soundOn: Bool){
        if let menuMusicPlayer = menuMusicPlayer{
            menuMusicPlayer.volume = soundOn ? 0.7 : 0.0
        }
        if let gameMusicPlayer = gameMusicPlayer{
            gameMusicPlayer.volume = soundOn ? 1.0 : 0.0
        }
    }
    
    private func animateImageView(_ completion: @escaping() -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            self.soundImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.soundImageView.transform = CGAffineTransform.identity
            }, completion: { _ in
                completion()
            })
        })
    }
    
    func playGameMusic() {
        if let musicURL = Bundle.main.url(forResource: "game", withExtension: "mp3") {
            do {
                gameMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                gameMusicPlayer?.numberOfLoops = -1
                guard let gameMusicPlayer = gameMusicPlayer else {
                    gameMusicPlayer?.volume = soundOn ? 1.0 : 0.0
                    gameMusicPlayer?.play()
                    return
                }
                if !gameMusicPlayer.isPlaying{
                    gameMusicPlayer.volume = soundOn ? 1.0 : 0.0
                    gameMusicPlayer.play()
                }
            } catch {
                print("Не вдалося відтворити музику: \(error)")
            }
        }
    }
    
    func resumeMenuMusic() {
        menuMusicPlayer?.play()
    }
    
    func resumeGameMusic() {
        gameMusicPlayer?.play()
    }
    
    func stopGameMusic() {
        gameMusicPlayer?.stop()
        gameMusicPlayer?.currentTime = 0
    }
    
    private func playMenuMusic() {
        if let musicURL = Bundle.main.url(forResource: "menu", withExtension: "mp3") {
            do {
                menuMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                menuMusicPlayer?.numberOfLoops = -1
                menuMusicPlayer?.volume = soundOn ? 0.7 : 0.0
                menuMusicPlayer?.play()
            } catch {
                print("Не вдалося відтворити музику: \(error)")
            }
        }
    }
    
    func stopMenuMusic() {
        menuMusicPlayer?.stop()
        menuMusicPlayer?.currentTime = 0
    }
}
