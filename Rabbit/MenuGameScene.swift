import SpriteKit

class MenuGameScene: SKScene {
    
    private var playSprite = SKSpriteNode(imageNamed: "button")
    private let bgSprite = SKSpriteNode(imageNamed: "bg")
    private let rabbitSprite = SKSpriteNode(imageNamed: "menuRabbit")
    private var titleSprite = SKSpriteNode(imageNamed: "logoRabbit")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addBG()
        addPlaySprite()
        addMenuRabbit()
        addTitle()
        if let gameViewController = self.view!.window?.rootViewController as? GameViewController {
            gameViewController.resumeMenuMusic()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        for node in touchedNodes {
            if node.name == "play" {
                playTap()
            }
        }
    }
    
    private func addBG() {
        bgSprite.size = CGSize(width: size.width, height: size.height)
        bgSprite.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgSprite)
    }
    
    private func addPlaySprite() {
        let scale = 0.18
        playSprite.name = "play"
        playSprite.size = CGSize(width: playSprite.size.width * scale, height: playSprite.size.height * scale)
        playSprite.position = CGPoint(x: frame.midX, y: frame.midY - size.height * 0.05)
        addChild(playSprite)
        
        var label = SKLabelNode(text: "play")
        label.verticalAlignmentMode = .center
        label.numberOfLines = 0
        addShadow(&label, shadowColor: .black)
        playSprite.addChild(label)
    }
    
    private func playTap() {
        let zoomOut = SKAction.scale(to: 0.8, duration: 0.15)
        let zoomBack = SKAction.scale(to: 1.0, duration: 0.15)
        let sequence = SKAction.sequence([zoomOut, zoomBack])
        playSprite.run(sequence, completion: goToScene)
    }
    
    private func goToScene(){
        let scene = LevelsScene(size: self.view!.bounds.size)
        scene.scaleMode = SKSceneScaleMode.resizeFill
        self.view!.presentScene(scene)
    }
    
    private func addMenuRabbit() {
        let scale = 0.5
        rabbitSprite.size = CGSize(width: rabbitSprite.size.width * scale, height: rabbitSprite.size.height * scale)
        rabbitSprite.position = CGPoint(x: frame.midX, y: frame.minY + playSprite.size.height)
        addChild(rabbitSprite)
    }
    
    private func addTitle() {
        let scale = 0.4
        titleSprite.size = CGSize(width: titleSprite.size.width * scale, height: titleSprite.size.height * scale)
        titleSprite.position = CGPoint(x: frame.midX, y: frame.maxY - size.height * 0.1)
        titleSprite.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        addChild(titleSprite)
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
            .font: UIFont(name: "EasterLover-Regular",size: 36) ?? UIFont.systemFont(ofSize: 30),
            .foregroundColor: UIColor.white
        ], range: range)
        label.attributedText = attrString
    }
}
 
