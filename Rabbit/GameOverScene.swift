import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var text = ""
    var level: Levels = .desertGameScene
    var levelForSaving = UserDefaults.standard.integer(forKey: "LevelForSavingKey")
    private let bg = SKSpriteNode(imageNamed: "gameOver")
    private var title = SKLabelNode()
    private var rabbit = SKSpriteNode()
    private var board = SKSpriteNode()
    private var restartSprite = SKSpriteNode(imageNamed: "restart")
    private var menuSprite = SKSpriteNode(imageNamed: "menu")
    private var nextSprite = SKSpriteNode(imageNamed: "next")
    private var starSprite = SKSpriteNode()
    private var labelSprite = SKSpriteNode()
    private let buttonsScale = 0.35
    var isWin = false
    let customYellow = UIColor(red: 252/255, green: 225/255, blue: 74/255, alpha: 1.0)
    let customBrown = UIColor(red: 157/255, green: 67/255, blue: 34/255, alpha: 1.0)
    let customBlue = UIColor(red: 63/255, green: 106/255, blue: 177/255, alpha: 1.0)
    let customGreen = UIColor(red: 104/255, green: 196/255, blue: 170/255, alpha: 1.0)
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        addBG()
        addBoard()
        addGhost()
        addLabel()
        addRestartButton()
        addMenuButton()
        addNextButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        for node in touchedNodes {
            if node.name == "restart" {
                presentAction(restartSprite)
                if let gameViewController = view!.window?.rootViewController as? GameViewController {
                    gameViewController.stopGameMusic()
                }
            }
            
            if node.name == "menu" {
                self.level = .menuGameScene
                presentAction(menuSprite)
            }
            
            if node.name == "next" {
                level = level == .iceGameScene ? .menuGameScene : level
                guard let nextLevel = Levels(rawValue: level.rawValue + 1) else{return}
                self.level = nextLevel
                saveLevelForSaving(levelForSaving + 1)
                presentAction(nextSprite)
            }
        }
    }
    
    private func addBG() {
        bg.size = CGSize(width: size.width, height: size.height)
        bg.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bg)
    }
    
    private func addGhost() {
        let ghost = SKSpriteNode(imageNamed: "ghost")
        let scale = 0.5
        ghost.size = CGSize(width: ghost.size.width * scale, height: ghost.size.height * scale)
        ghost.position = CGPoint(x: frame.midX, y: frame.maxY - size.height * 0.1)
        ghost.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        if !isWin{
            if let gameViewController = view!.window?.rootViewController as? GameViewController {
                gameViewController.stopGameMusic()
            }
            let sounAction = SKAction.playSoundFileNamed("ghost.mp3", waitForCompletion: false)
            self.run(sounAction)
            addChild(ghost)
        }
    }
    
    private func addRabbit() {
        addRabbitpparance()
        addRabbitAction()
        rabbit.position = CGPoint(x: frame.midX + size.width * 0.15, y: frame.midY - size.height * 0.05)
        rabbit.zPosition = 10000
        addChild(rabbit)
    }
    
    private func addRabbitpparance() {
        let texture = SKTexture(imageNamed: "rabbit-Star-0")
        rabbit = SKSpriteNode(texture: texture)
        rabbit.size.width = size.width * 0.25
        rabbit.size.height = size.height * 0.4
    }

    private func addRabbitAction(){
        var textureArray = [SKTexture]()
        let range = 0...1
        range.forEach{textureArray.append(SKTexture(imageNamed: "rabbit-Star-\(String($0))"))}
        let action = SKAction.animate(with: textureArray, timePerFrame: 0.18)
        rabbit.run(SKAction.repeatForever(action))
    }
    
    private func addBoard() {
        board = SKSpriteNode(imageNamed: "board")
        board.size.width = size.width * 0.8
        board.size.height = frame.size.height
        board.position = CGPoint(x: frame.midX, y: frame.maxY)
        board.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        board.alpha = 0.9
        addChild(board)
    }
    
    private func addLabel() {
        title = SKLabelNode(text: isWin ? "The rabbit \nmAnaged to escape !" : "The rabbit \nDid not run away !")
        title.preferredMaxLayoutWidth = size.width * 0.7
        title.verticalAlignmentMode = .top
        title.numberOfLines = 2
        title.position = CGPoint(x: frame.midX, y: isWin ? (frame.maxY - size.height * 0.1) : frame.midY + size.height * 0.1)
        addChild(title)
        addShadow(&title, textColor: .white, shadowColor: customBlue, fontSize: 40)
    }
    
    private func addShadow(_ label: inout SKLabelNode, textColor: UIColor, shadowColor: UIColor, fontSize: CGFloat) {
        guard let text = label.text else{return}
        let range = NSRange(location: 0, length: text.count)
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 9.0, height: 8.0)
        shadow.shadowBlurRadius = 3.0
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([
            .shadow: shadow,
            .font: UIFont(name: "EasterLover-Regular",size: fontSize) ?? UIFont.systemFont(ofSize: 30),
            .foregroundColor: textColor
        ], range: range)
        label.attributedText = attrString
    }
    
    
    private func addRestartButton() {
        restartSprite.setScale(buttonsScale)
        restartSprite.position = CGPoint(x: isWin ? frame.midX : frame.maxX - size.width * 0.3, y: frame.minY + size.height * 0.2)
        restartSprite.name = "restart"
        addChild(restartSprite)
    }
    
    private func presentAction(_ sprite: SKSpriteNode) {
        let duration = 0.1
        let zoomOut = SKAction.scale(to: buttonsScale - 0.05, duration: duration)
        let zoomBack = SKAction.scale(to: buttonsScale, duration: duration)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        sprite.run(sequence, completion: goToScene)
    }
    
    private func addMenuButton() {
        menuSprite.setScale(buttonsScale)
        menuSprite.position = CGPoint(x: frame.minX + size.width * 0.3, y: frame.minY + size.height * 0.2)
        menuSprite.name = "menu"
        addChild(menuSprite)
    }

    private func goToScene(){
        let scene = choose()
        scene.scaleMode = SKSceneScaleMode.resizeFill
        self.view!.presentScene(scene)
    }
    
    private func choose() -> SKScene {
        var scene: SKScene
        switch level {
        case .nightGameScene:
            scene = NightGameScene(size: self.view!.bounds.size)
        case .gameScene:
            scene = GameScene(size: self.view!.bounds.size)
        case .desertGameScene:
            scene = DesertGameScene(size: self.view!.bounds.size)
        case .iceGameScene:
            scene = IceGameScene(size: self.view!.bounds.size)
        case .beachGameScene:
            scene = BeachGameScene(size: self.view!.bounds.size)
        case .menuGameScene:
            if let gameViewController = self.view!.window?.rootViewController as? GameViewController {
                gameViewController.stopGameMusic()
            }
            scene = MenuGameScene(size: self.view!.bounds.size)
        }
        return scene
    }
    
    private func addNextButton() {
        guard isWin else{return}
        let sounAction = SKAction.playSoundFileNamed("woah.mp3", waitForCompletion: false)
        self.run(sounAction)
        nextSprite.setScale(buttonsScale)
        nextSprite.position = CGPoint(x: frame.maxX - size.width * 0.3, y: frame.minY + size.height * 0.2)
        nextSprite.name = "next"
        addChild(nextSprite)
    }
    
    private func nextAction() {
        let duration = 0.1
        let zoomOut = SKAction.scale(to: 0.2, duration: duration)
        let zoomBack = SKAction.scale(to: 0.35, duration: duration)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        nextSprite.run(sequence, completion: goToScene)
    }
    
    func configStar(_ carrotCounter: Int) {
        guard isWin else{return}
        switch carrotCounter {
        case 0:
            starSprite = SKSpriteNode(imageNamed: "gold")
            labelSprite = SKSpriteNode(imageNamed: "goldLabel")
            saveGoldStar()
        case 1:
            starSprite = SKSpriteNode(imageNamed: "silver")
            labelSprite = SKSpriteNode(imageNamed: "silverLabel")
            saveSilverStar()
        default:
            starSprite = SKSpriteNode(imageNamed: "bronze")
            labelSprite = SKSpriteNode(imageNamed: "bronzeLabel")
            saveBronzeStar()
        }
        addStarSprite()
        addLabelSprite()
        addRabbit()
        let level = levelForSaving + 1
        saveIsOpen(String(level))
    }
    
    private func addStarSprite() {
        let scale = 0.1
        starSprite.size = CGSize(width: starSprite.size.width * scale, height: starSprite.size.height * scale)
        starSprite.position = CGPoint(x: frame.minX + size.width * 0.35, y: frame.midY + size.height * 0.05)
        starSprite.zPosition = 10000
        addChild(starSprite)
        configStarAction()
    }
    
    private func configStarAction() {
        let scaleUp = SKAction.scale(to: 2.0, duration: 1.0)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        starSprite.run(SKAction.repeatForever(sequence))
    }
    
    private func addLabelSprite() {
        let scale = 0.4
        labelSprite.size = CGSize(width: labelSprite.size.width * scale, height: labelSprite.size.height * scale)
        labelSprite.position = CGPoint(x: frame.minX + size.width * 0.35, y: frame.midY - size.height * 0.1)
        labelSprite.zPosition = 10000
        addChild(labelSprite)
        configLabelSpriteAction()
    }
    
    private func configLabelSpriteAction() {
        let scaleUp = SKAction.scale(to: 1.2, duration: 1.0)
        let scaleDown = SKAction.scale(to: 1.0, duration: 1.0)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        labelSprite.run(SKAction.repeatForever(sequence))
    }
    
    private func saveBronzeStar() {
        let bronzeKey = "bronze"
        let levelKey = levelForSaving
        UserDefaults.standard.set(true, forKey: "\(levelKey)\(bronzeKey)")
    }
    
    private func saveSilverStar() {
        let silverKey = "silver"
        let levelKey = levelForSaving
        UserDefaults.standard.set(true, forKey: "\(levelKey)\(silverKey)")
    }
    
    private func saveGoldStar() {
        let goldKey = "gold"
        let levelKey = levelForSaving
        UserDefaults.standard.set(true, forKey: "\(levelKey)\(goldKey)")
    }
    
    private func saveIsOpen(_ level: String) {
        print("Open \(level) level")
        UserDefaults.standard.set(true, forKey: "\(level)")
    }
    
    private func saveLevelForSaving(_ level: Int) {
        UserDefaults.standard.set(level, forKey: "LevelForSavingKey")
    }
    
    private func loadLevelForSaving() -> Int {
        UserDefaults.standard.integer(forKey: "LevelForSavingKey")
    }
}
