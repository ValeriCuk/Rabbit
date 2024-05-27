import SpriteKit

class LevelsScene: SKScene {
    
    private var buttonSprite = SKSpriteNode(imageNamed: "button2")
    private let bgSprite = SKSpriteNode(imageNamed: "bg")
    private var title = SKLabelNode()
    private var horizontalInterval = 0.0
    private var verticalInterval = 0.0
    private var currentLevel: Levels = .menuGameScene
    private var menuSprite = SKSpriteNode(imageNamed: "menu")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        horizontalInterval = size.width / 6
        addBG()
        addLevels()
        addTitle()
        addMenuButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        for node in touchedNodes {
            switch node.name {
            case "1":
                saveLevelForSaving(1)
                currentLevel = .gameScene
                openGame(node)
            case "2":
                guard loadIsOpen("2") else{return}
                saveLevelForSaving(2)
                currentLevel = .nightGameScene
                openGame(node)
            case "3":
                guard loadIsOpen("3") else{return}
                saveLevelForSaving(3)
                currentLevel = .beachGameScene
                openGame(node)
            case "4":
                guard loadIsOpen("4") else{return}
                saveLevelForSaving(4)
                currentLevel = .desertGameScene
                openGame(node)
            case "5":
                guard loadIsOpen("5") else{return}
                saveLevelForSaving(5)
                currentLevel = .iceGameScene
                openGame(node)
            case "6":
                guard loadIsOpen("6") else{return}
                saveLevelForSaving(6)
                currentLevel = .gameScene
                openGame(node)
            case "7":
                guard loadIsOpen("7") else{return}
                saveLevelForSaving(7)
                currentLevel = .nightGameScene
                openGame(node)
            case "8":
                guard loadIsOpen("8") else{return}
                saveLevelForSaving(8)
                currentLevel = .beachGameScene
                openGame(node)
            case "9":
                guard loadIsOpen("9") else{return}
                saveLevelForSaving(9)
                currentLevel = .desertGameScene
                openGame(node)
            case "10":
                guard loadIsOpen("10") else{return}
                saveLevelForSaving(10)
                currentLevel = .iceGameScene
                openGame(node)
            case "menu":
                print("MENU->")
                presentAction(menuSprite)
            default:
                print("Wrong tap!")
            }
        }
    }
    
    private func openGame(_ node: SKNode) {
        if let gameViewController = self.view!.window?.rootViewController as? GameViewController {
            gameViewController.stopMenuMusic()
        }
        let zoomOut = SKAction.scale(to: 0.8, duration: 0.15)
        let zoomBack = SKAction.scale(to: 1.0, duration: 0.15)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        node.run(sequence, completion: goToScene)
    }
    
    private func goToScene(){
        let scene = getLevel()
        scene.scaleMode = SKSceneScaleMode.resizeFill
        self.view!.presentScene(scene)
    }
    
    private func getLevel() -> SKScene {
        var scene = SKScene()
        switch currentLevel {
        case .nightGameScene:
            scene = NightGameScene(size: self.view!.bounds.size)
        case .gameScene:
            scene =  GameScene(size: self.view!.bounds.size)
        case .desertGameScene:
            scene = DesertGameScene(size: self.view!.bounds.size)
        case .iceGameScene:
            scene = IceGameScene(size: self.view!.bounds.size)
        case .beachGameScene:
            scene = BeachGameScene(size: self.view!.bounds.size)
        case .menuGameScene:
            scene = MenuGameScene(size: self.view!.bounds.size)
        }
        return scene
    }
    
    private func addBG() {
        bgSprite.size = CGSize(width: size.width, height: size.height)
        bgSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgSprite)
    }
    
    private func addLevels() {
        let range = 1...10
        for i in range{
            let level = String(i)
            addLevelSprite(level)
        }
    }
    
    private func addLevelSprite(_ level: String) {
        firstSavingOpen(level)
        firtsSavingStarsState(level)
        let levelNum: Double = Double(level) ?? 0
        let scale = loadIsOpen(level) ? 0.35 : 0.2
        let sprite = buttonSprite.copy() as! SKSpriteNode
        let yPosition = levelNum < 6.0 ? frame.midY + size.height * 0.1 : frame.midY - size.height * 0.2
        let xPosition = levelNum < 6.0 ? frame.minX + horizontalInterval * levelNum : frame.minX + horizontalInterval * (levelNum - 5)
        sprite.size = CGSize(width: sprite.size.width * scale, height: sprite.size.height * scale)
        sprite.position = CGPoint(x: xPosition, y: yPosition)
        sprite.name = level
        addChild(sprite)
        sprite.alpha = loadIsOpen(level) ? 1.0 : 0.5
        var label = SKLabelNode(text: level)
        label.verticalAlignmentMode = .center
        addShadow(&label, shadowColor: .black)
        sprite.addChild(label)
        addStars(to: sprite)
    }
    
    private func addStars(to sprite: SKSpriteNode) {
        let level = sprite.name ?? "level"
        let stars = loadStarsIsOpen(level)
        let scale = loadIsOpen(level) ? 0.1 : 0.07
        let goldStar = SKSpriteNode(imageNamed: stars.gold ? "gold": "gold-empty")
        let silverStar = SKSpriteNode(imageNamed: stars.silver ? "silver": "silver-empty")
        let bronzeStar = SKSpriteNode(imageNamed: stars.bronze ? "bronze": "bronze-empty")
        let starsArray = [bronzeStar, silverStar, goldStar]
        var interval = -silverStar.size.width * scale
        starsArray.forEach{
            $0.size = CGSize(width: $0.size.width * scale, height: $0.size.height * scale)
            sprite.addChild($0)
            $0.position.y = -sprite.size.height/2
            $0.position.x = interval
            interval += $0.size.width
        }
    }
    
    private func loadIsOpen(_ level: String) -> Bool {
        UserDefaults.standard.bool(forKey: "\(level)")
    }

    private func firstSavingOpen(_ level: String) {
        UserDefaults.standard.set(true, forKey: "1")
        guard let _ = UserDefaults.standard.object(forKey: "\(level)") else{
            UserDefaults.standard.set(false, forKey: "\(level)")
            return
        }
    }
    
    private func firtsSavingStarsState(_ level: String) {
        firstSaveBronze(level)
        firstSaveSilver(level)
        firstSaveGold(level)
    }
    
    private func firstSaveGold(_ level: String) {
        let goldKey = "gold"
        let levelKey = level
        guard let _ = UserDefaults.standard.object(forKey: "\(levelKey)\(goldKey)") else{
            UserDefaults.standard.set(false, forKey: "\(levelKey)\(goldKey)")
            return
        }
    }
    
    private func firstSaveSilver(_ level: String) {
        let silverKey = "silver"
        let levelKey = level
        guard let _ = UserDefaults.standard.object(forKey: "\(levelKey)\(silverKey)") else{
            UserDefaults.standard.set(false, forKey: "\(levelKey)\(silverKey)")
            return
        }
    }
    
    private func firstSaveBronze(_ level: String) {
        let bronzeKey = "bronze"
        let levelKey = level
        guard let _ = UserDefaults.standard.object(forKey: "\(levelKey)\(bronzeKey)") else{
            UserDefaults.standard.set(false, forKey: "\(levelKey)\(bronzeKey)")
            return
        }
    }
    
    private func loadStarsIsOpen(_ level: String) -> Stars {
        let goldKey = "gold"
        let silverKey = "silver"
        let bronzeKey = "bronze"
        let levelKey = level
        let stars = Stars(
            bronze: UserDefaults.standard.bool(forKey: "\(levelKey)\(bronzeKey)"),
            silver: UserDefaults.standard.bool(forKey: "\(levelKey)\(silverKey)"),
            gold: UserDefaults.standard.bool(forKey: "\(levelKey)\(goldKey)")
        )
        print(stars)
        return stars
    }

    private func addTitle() {
        let textColor = UIColor.white
        let textFont = UIFont(name: "EasterLover-Regular",size: 40) ?? UIFont.systemFont(ofSize: 30)
        let yourString = "LeveLs"
        let range = NSRange(location: 0, length: yourString.count)
        let attrString = NSMutableAttributedString(string: yourString)
        let paragraphStyle = NSMutableParagraphStyle()
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: 8.0, height: 7.0)
        shadow.shadowBlurRadius = 5.0
        paragraphStyle.alignment = .center
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([
            .foregroundColor : textColor,
            .font : textFont,
            .shadow: shadow
        ], range: range)
        
        title.attributedText = attrString
        title.verticalAlignmentMode = .top
        title.preferredMaxLayoutWidth = size.width * 0.8
        title.numberOfLines = 0
        title.position = CGPoint(x: frame.midX, y: frame.maxY - size.height * 0.1)
        addChild(title)
    }
    
    private func addShadow(_ label: inout SKLabelNode, shadowColor: UIColor) {
        guard let text = label.text else{return}
        let range = NSRange(location: 0, length: text.count)
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 5.0, height: 5.0)
        shadow.shadowBlurRadius = 10.0
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([
            .shadow: shadow,
            .font: UIFont(name: "EasterLover-Regular",size: loadIsOpen(text) ? 36 : 26) ?? UIFont.systemFont(ofSize: 30),
            .foregroundColor: UIColor.white
        ], range: range)
        label.attributedText = attrString
    }
    
    private func saveLevelForSaving(_ level: Int) {
        UserDefaults.standard.set(level, forKey: "LevelForSavingKey")
    }
    
    private func addMenuButton() {
        menuSprite.setScale(0.35)
        menuSprite.alpha = 0.9
        menuSprite.position = CGPoint(x: frame.maxX - size.width * 0.1, y: frame.maxY - size.height * 0.15)
        menuSprite.name = "menu"
        addChild(menuSprite)
    }
    
    private func presentAction(_ sprite: SKSpriteNode) {
        let duration = 0.1
        let zoomOut = SKAction.scale(to: 0.3, duration: duration)
        let zoomBack = SKAction.scale(to: 0.35, duration: duration)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        sprite.run(sequence, completion: goToScene)
    }
}
