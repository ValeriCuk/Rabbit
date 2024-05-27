import SpriteKit

class NightGameScene: SKScene{
    
    private var lastUpdateTime: TimeInterval = 0
    private var bgSpritesArray = [SKSpriteNode]()
    private var groundLastUpdateTime: TimeInterval = 0
    private let groundgroundSpeed: CGFloat = 150
    private var groundSpritesArray = [SKSpriteNode]()
    private var moonSprite = SKSpriteNode(texture: SKTexture(imageNamed: "moon"))
    private let backgroundSpeed: CGFloat = 40
    private var helpScreen = SKShapeNode()
    private var stumpSprite = SKSpriteNode()
    private var carrotSprite = SKSpriteNode()
    private var jumpSprite = SKSpriteNode()
    private var helpLabel = SKLabelNode()
    private var rabbit = SKSpriteNode()
    private var wolf = SKSpriteNode()
    private var moveSpeed: CGFloat = 1.5
    private var wolfSpeed: CGFloat = 40.0
    private let wolfCategoryBitMask: UInt32 = 2
    private let rabbitCategoryBitMask: UInt32 = 4
    private let stumpCategoryBitMask: UInt32 = 8
    private let decorationCategoryBitMask: UInt32 = 16
    private let carrotCategoryBitMask: UInt32 = 32
    private var onTheGround = true
    private var carrotCounter = 0
    private var pauseSprite = SKSpriteNode(imageNamed: "pause")
    private var menuSprite = SKSpriteNode(imageNamed: "menu")
    private var playSprite = SKSpriteNode(imageNamed: "play")
    private var pause = false
    
    override func didMove(to view: SKView) {
        isPaused = true
        self.backgroundColor = .gray
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        confiBackground()
        configGroung()
        addMoon()
        addRabbit()
        addWolf()
        addRun()
        addHelpScreen()
        addJumpButton()
        createCarrotSprite()
        createStumpSprite()
        addPauseSprite()
        addMenuButton()
        addPlayButton()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateBackground(currentTime)
        updateGround(currentTime)
        if rabbit.position.x > size.width {
            self.isPaused = true
            self.isUserInteractionEnabled = false
            goToGameOverScene(true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        if !helpScreen.isHidden && !pause{
            helpScreen.isHidden = true
            isPaused = false
            if let gameViewController = view!.window?.rootViewController as? GameViewController {
                gameViewController.playGameMusic()
            }
        }
        if !pause {
            rabbit.position.x += moveSpeed
        }
        for node in touchedNodes {
            if node.name == "jump" {
                jumpSpriteTap()
            }
            if node.name == "pause" {
                print("PAUSE")
                pauseAction()
            }
            if node.name == "menu" {
                print("MENU")
                isPaused = false
                presentAction()
            }
            if node.name == "play" {
                print("PLAY")
                playAction()
                isPaused = false
            }
        }
    }
    
    private func confiBackground() {
        for i in 0...1 {
            let backgroundSprite = SKSpriteNode(imageNamed: "scene-\(String(i))")
            backgroundSprite.size = CGSize(width: self.frame.width, height: self.frame.height * 0.95)
            backgroundSprite.zPosition = -5000
            backgroundSprite.position = CGPoint(x:  CGFloat(i) * backgroundSprite.size.width, y: frame.midY + self.frame.height * 0.1)
            addChild(backgroundSprite)
            bgSpritesArray.append(backgroundSprite)
        }
    }

    private func updateBackground(_ currentTime: TimeInterval) {
        guard lastUpdateTime > 0 else {
            lastUpdateTime = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdateTime
        bgSpritesArray.forEach { backgroundSprite in
            backgroundSprite.position.x -= backgroundSpeed * CGFloat(deltaTime)
            if backgroundSprite.position.x <= frame.minX - backgroundSprite.size.width / 2 {
                backgroundSprite.position.x += backgroundSprite.size.width * CGFloat(bgSpritesArray.count)
            }
        }
        lastUpdateTime = currentTime
    }
    
    private func configGroung() {
        for i in 0...1 {
            let backgroundSprite = SKSpriteNode(imageNamed: "night-ground-\(String(i))")
            backgroundSprite.size = CGSize(width: self.frame.width, height: self.frame.height * 0.3)
            backgroundSprite.anchorPoint = CGPoint(x: 0, y: 0)
            backgroundSprite.zPosition = -5000
            backgroundSprite.position = CGPoint(x:  CGFloat(i) * backgroundSprite.size.width, y: frame.minY)
            addChild(backgroundSprite)
            groundSpritesArray.append(backgroundSprite)
        }
    }
    
    private func updateGround(_ currentTime: TimeInterval) {
        guard groundLastUpdateTime > 0 else {
            groundLastUpdateTime = currentTime
            return
        }
        
        let deltaTime = currentTime - groundLastUpdateTime
        groundSpritesArray.forEach { backgroundSprite in
            backgroundSprite.position.x -= groundgroundSpeed * CGFloat(deltaTime)
            if backgroundSprite.position.x <= frame.minX - backgroundSprite.size.width {
                backgroundSprite.position.x += backgroundSprite.size.width * CGFloat(groundSpritesArray.count)
                backgroundSprite.removeAllChildren()
                if rabbit.position.x < frame.maxX - frame.size.width * 0.3 {
                    addStumpTo(backgroundSprite)
                    addCarrotTo(backgroundSprite)
                    print("Carrot add: \(carrotCounter)")
                }
            }
        }
        groundLastUpdateTime = currentTime
    }
    
    private func addMoon(){
        let scale = 0.13
        moonSprite.size = CGSize(width: moonSprite.size.width * scale, height: moonSprite.size.height * scale)
        moonSprite.position = CGPoint(x: frame.maxX - moonSprite.size.width, y: frame.maxY - moonSprite.size.height)
        moonSprite.alpha = 0.3
        let moveLeft = SKAction.moveTo(x: moonSprite.size.width, duration: 100.0)
        moonSprite.run(moveLeft)
        addChild(moonSprite)
    }
    
    private func addRabbit() {
        addRabbitAppearance()
        configRabbitPhysicsBody()
        addRabbitAction()
        rabbit.position = CGPoint(x: frame.minX + rabbit.size.width * 1.5, y: frame.minY + size.height * 0.2)
        addChild(rabbit)
    }
    
    private func addRabbitAppearance() {
        let texture = SKTexture(imageNamed: "rabbit-running-0")
        rabbit = SKSpriteNode(texture: texture)
        rabbit.size.width = size.width * 0.15
        rabbit.size.height = size.height * 0.2
        rabbit.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: rabbit.size.width, height: rabbit.size.height))
    }
    
    private func configRabbitPhysicsBody() {
        rabbit.physicsBody?.isDynamic = true
        rabbit.physicsBody?.categoryBitMask = rabbitCategoryBitMask
        rabbit.physicsBody?.contactTestBitMask = wolfCategoryBitMask
        rabbit.physicsBody?.contactTestBitMask = stumpCategoryBitMask
        rabbit.physicsBody?.contactTestBitMask = carrotCategoryBitMask
        rabbit.physicsBody?.collisionBitMask &= ~wolfCategoryBitMask
        rabbit.physicsBody?.collisionBitMask &= ~stumpCategoryBitMask
        rabbit.physicsBody?.collisionBitMask &= ~carrotCategoryBitMask
    }
    
    private func addRabbitAction() {
        let textureArray = [
            SKTexture(imageNamed: "rabbit-running-0"),
            SKTexture(imageNamed: "rabbit-running-1")
        ]
        let action = SKAction.animate(with: textureArray, timePerFrame: 0.1)
        rabbit.run(SKAction.repeatForever(action))
    }
    
    private func addWolf() {
        addWolfApparance()
        configWolfPhysicsBody()
        addWolfAction()
        wolf.position = CGPoint(x: frame.minX - wolf.size.width * 0.3, y: frame.minY + size.height * 0.3)
        addChild(wolf)
    }
    
    private func addWolfApparance() {
        let texture = SKTexture(imageNamed: "dark-wolf-0")
        wolf = SKSpriteNode(texture: texture)
        wolf.size.width = size.width * 0.5
        wolf.size.height = size.height * 0.4
        wolf.physicsBody = SKPhysicsBody(texture: texture, size: wolf.size)
    }
    
    private func configWolfPhysicsBody() {
        wolf.physicsBody?.isDynamic = true
        wolf.physicsBody?.categoryBitMask = wolfCategoryBitMask
        wolf.physicsBody?.contactTestBitMask = rabbitCategoryBitMask
        wolf.physicsBody?.collisionBitMask &= ~rabbitCategoryBitMask
        wolf.physicsBody?.collisionBitMask &= ~stumpCategoryBitMask
    }
    
    private func addWolfAction(){
        var textureArray = [SKTexture]()
        let range = 0...6
        range.forEach{textureArray.append(SKTexture(imageNamed: "dark-wolf-\(String($0))"))}
        let action = SKAction.animate(with: textureArray, timePerFrame: 0.08)
        wolf.run(SKAction.repeatForever(action))
        let runRight = SKAction.moveTo(x: size.width, duration: 40.0)
        wolf.run(runRight)
        let musicAction = SKAction.playSoundFileNamed("wolf.mp3", waitForCompletion: false)
        wolf.run(musicAction)
    }
    
    private func addRun() {
        let run = SKSpriteNode(imageNamed: "run")
        run.alpha = 0
        let oneAlphaAction = SKAction.fadeIn(withDuration: 0.5)
        let scaleAction = SKAction.scale(by: 1.5, duration: 0.5)
        let zeroAlphaAction = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = [oneAlphaAction, scaleAction, zeroAlphaAction, remove]
        run.run(SKAction.sequence(sequence))
        run.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(run)
    }

    private func addHelpScreen() {
        helpScreen =  SKShapeNode(rect: CGRect(x: frame.minX, y: frame.minY, width: size.width, height: size.height))
        helpScreen.fillColor = .black.withAlphaComponent(0.7)
        helpScreen.zPosition = 50000
        addChild(helpScreen)
        helpLabel = SKLabelNode(text: "Tap The screen Quickly \nTo escape from The wolf")
        helpLabel.preferredMaxLayoutWidth = size.width
        addShadow(&helpLabel, shadowColor: .black)
        helpLabel.numberOfLines = 2
        helpLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        helpScreen.addChild(helpLabel)
    }
    
    private func addShadow(_ label: inout SKLabelNode, shadowColor: UIColor) {
        guard let text = label.text else{return}
        let range = NSRange(location: 0, length: text.count)
        let shadow = NSShadow()
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: 5.0, height: 5.0)
        shadow.shadowBlurRadius = 5.0
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([
            .shadow: shadow,
            .font: UIFont(name: "EasterLover-Regular",size: 50) ?? UIFont.systemFont(ofSize: 30),
            .foregroundColor: UIColor.white
        ], range: range)
        label.attributedText = attrString
    }
    
    private func goToGameOverScene(_ isWin: Bool){
        print("Carrot left: \(carrotCounter)")
        let gameOverScene: GameOverScene = GameOverScene(size: self.view!.bounds.size)
        gameOverScene.isWin = isWin
        gameOverScene.level = .nightGameScene
        gameOverScene.configStar(carrotCounter)
        let transition = SKTransition.fade(withDuration: 1.0)
        gameOverScene.scaleMode = SKSceneScaleMode.resizeFill
        self.view!.presentScene(gameOverScene, transition: transition)
    }
    
    private func createStumpSprite() {
        stumpSprite = SKSpriteNode(texture: SKTexture(imageNamed: "camp-fire-17"))
        let scale = 0.2
        stumpSprite.size = CGSize(width: stumpSprite.size.width * scale, height: stumpSprite.size.height * scale)
        stumpSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        animateStump()
        addPhysicsBodyStump()
    }
    
    private func animateStump() {
        let range = 0...15
        var textures: [SKTexture] = []
        range.forEach{textures.append(SKTexture(imageNamed: "camp-fire-\($0)"))}
        let action = SKAction.animate(with: textures, timePerFrame: 0.1)
        stumpSprite.run(SKAction.repeatForever(action))
    }
    
    private func addPhysicsBodyStump() {
        stumpSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "camp-fire-17"), size: CGSize(width: stumpSprite.size.width, height: stumpSprite.size.height))
        stumpSprite.physicsBody?.categoryBitMask = stumpCategoryBitMask
        stumpSprite.physicsBody?.contactTestBitMask = rabbitCategoryBitMask
        stumpSprite.physicsBody?.collisionBitMask &= ~rabbitCategoryBitMask
        stumpSprite.physicsBody?.collisionBitMask &= ~wolfCategoryBitMask
        stumpSprite.physicsBody?.collisionBitMask &= ~carrotCategoryBitMask
    }
    
    private func addStumpTo(_ sprite: SKSpriteNode) {
        let stump = stumpSprite.copy() as! SKSpriteNode
        let maxX = frame.midX - stump.size.width * 0.5
        let minX = frame.minX + stump.size.width  * 0.5
        let yPosition = frame.minY + sprite.size.height * 0.8
        let xPosition = Double.random(in: minX...maxX)
        stump.position = CGPoint(x: xPosition, y: yPosition)
        stump.zPosition = 10000
        sprite.addChild(stump)
    }
    
    private func rabbitJump() {
        let range = 0...5
        var textures: [SKTexture] = []
        range.forEach{textures.append(SKTexture(imageNamed: "jumping-rabbit-\($0)"))}
        let duration = 0.5
        let x = frame.size.width * 0.03
        let y = frame.size.height * 0.35
        let jump = SKAction.moveBy(x: x, y: y, duration: duration)
        let back = SKAction.moveBy(x: x, y: -y, duration: duration)
        let changeNameAction = SKAction.run { [weak self] in
            self?.jumpSprite.name = "jump"
        }
        let sequense = SKAction.sequence([jump, back, changeNameAction])
        rabbit.run(sequense)
        rabbit.run(SKAction.animate(with: textures, timePerFrame: 0.18))
    }
    
    private func addJumpButton() {
        jumpSprite = SKSpriteNode(imageNamed: "jump")
        let scale = 0.12
        jumpSprite.size = CGSize(width: jumpSprite.size.width * scale, height: jumpSprite.size.height * scale)
        jumpSprite.name = "jump"
        jumpSprite.alpha = 0.5
        jumpSprite.position = CGPoint(x: frame.minX + jumpSprite.size.width, y: frame.minY + jumpSprite.size.height * 0.7)
        jumpSprite.zPosition = 40000
        addChild(jumpSprite)
    }
    
    private func jumpSpriteTap() {
        jumpSprite.name = "unknown"
        let zoomOut = SKAction.scale(to: 0.8, duration: 0.2)
        let zoomBack = SKAction.scale(to: 1.0, duration: 0.2)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        jumpSprite.run(sequence, completion: rabbitJump)
    }
    
    private func createCarrotSprite() {
        carrotSprite = SKSpriteNode(texture: SKTexture(imageNamed: "marshmallow"))
        carrotSprite.name = "marshmallow"
        let scale = 0.2
        carrotSprite.size = CGSize(width: carrotSprite.size.width * scale, height: carrotSprite.size.height * scale)
        addPhysicsBodyCarrot()
    }
    
    private func addPhysicsBodyCarrot() {
        carrotSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "marshmallow"), size: carrotSprite.size)
        carrotSprite.physicsBody?.categoryBitMask = carrotCategoryBitMask
        carrotSprite.physicsBody?.contactTestBitMask = rabbitCategoryBitMask
        carrotSprite.physicsBody?.collisionBitMask &= ~rabbitCategoryBitMask
        carrotSprite.physicsBody?.collisionBitMask &= ~wolfCategoryBitMask
        carrotSprite.physicsBody?.collisionBitMask &= ~stumpCategoryBitMask
    }
    
    private func addCarrotTo(_ sprite: SKSpriteNode) {
        let carrot = carrotSprite.copy() as! SKSpriteNode
        let maxX = frame.maxX - carrot.size.height
        let minX = frame.midX + carrot.size.width
        let yPosition = frame.minY + sprite.size.height * 1.5
        let xPosition = Double.random(in: minX...maxX)
        carrot.position = CGPoint(x: xPosition, y: yPosition)
        carrot.zPosition = 10000
        sprite.addChild(carrot)
        carrotCounter += 1
    }
    
    private func addPauseSprite() {
        pauseSprite.setScale(0.35)
        pauseSprite.alpha = 0.9
        pauseSprite.position = CGPoint(x: frame.maxX - size.width * 0.1, y: frame.maxY - size.height * 0.15)
        pauseSprite.name = "pause"
        addChild(pauseSprite)
    }
    
    private func pauseAction() {
        let duration = 0.1
        let zoomOut = SKAction.scale(to: 0.3, duration: duration)
        let zoomBack = SKAction.scale(to: 0.35, duration: duration)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        pauseSprite.run(sequence, completion: configGamePause)
    }
    
    private func configGamePause() {
        isPaused = true
        pause = true
        helpScreen.isHidden = false
        helpLabel.text = "P A U S E !"
        helpLabel.position = CGPoint(x: frame.midX, y: frame.midY + size.height * 0.2)
        addShadow(&helpLabel, shadowColor: .black)
        playSprite.isHidden = false
        menuSprite.isHidden = false
    }
    
    private func addPlayButton() {
        playSprite.isHidden = true
        playSprite.setScale(0.5)
        playSprite.alpha = 0.9
        playSprite.position = CGPoint(x: frame.midX + size.width * 0.1, y: frame.midY)
        playSprite.zPosition = 60000
        playSprite.name = "play"
        addChild(playSprite)
    }
    
    private func playAction() {
        let duration = 0.1
        let zoomOut = SKAction.scale(to: 0.45, duration: duration)
        let zoomBack = SKAction.scale(to: 0.5, duration: duration)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        playSprite.run(sequence, completion: play)
    }
    
    private func play() {
        helpScreen.isHidden = true
        menuSprite.isHidden = true
        playSprite.isHidden = true
        pause = false
    }
    
    private func addMenuButton() {
        menuSprite.isHidden = true
        menuSprite.setScale(0.5)
        menuSprite.alpha = 0.9
        menuSprite.position = CGPoint(x: frame.midX - size.width * 0.1, y: frame.midY)
        menuSprite.zPosition = 60000
        menuSprite.name = "menu"
        addChild(menuSprite)
    }
    
    private func presentAction() {
        let duration = 0.1
        let zoomOut = SKAction.scale(to: 0.45, duration: duration)
        let zoomBack = SKAction.scale(to: 0.5, duration: duration)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        menuSprite.run(sequence, completion: goToMenu)
    }
    
    private func goToMenu(){
        print("goToMenu")
        let scene = MenuGameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fade(withDuration: 1.0)
        scene.scaleMode = SKSceneScaleMode.resizeFill
        self.view!.presentScene(scene, transition: transition)
    }
    
}

extension NightGameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        let a: SKPhysicsBody = contact.bodyA
        let b: SKPhysicsBody = contact.bodyB

        if a.categoryBitMask == wolfCategoryBitMask || b.categoryBitMask == wolfCategoryBitMask {
            isPaused = true
            goToGameOverScene(false)
        }
        
        if a.categoryBitMask == stumpCategoryBitMask || b.categoryBitMask == stumpCategoryBitMask {
            isPaused = true
            goToGameOverScene(false)
        }
        
        if a.categoryBitMask == carrotCategoryBitMask || b.categoryBitMask == carrotCategoryBitMask {
            if let _ = a.node?.name{
                a.node?.removeFromParent()
                carrotCounter -= 1
                a.categoryBitMask = decorationCategoryBitMask
            }else {
                b.node?.removeFromParent()
                carrotCounter -= 1
                b.categoryBitMask = decorationCategoryBitMask
            }
        }
    }
}
