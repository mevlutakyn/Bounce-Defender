import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    enum ColliderType: UInt32 {
        case ball = 1
        case wood = 2
        case stone = 4
    }

    var wood = SKSpriteNode()
    var ball = SKSpriteNode()
    var stone = SKSpriteNode()
    var gameStart = true
    var ballPosition = CGPoint()
    var scoreLabel = SKLabelNode()
    var score = 0
    var hscore = 0
    var hscoreLabel = SKLabelNode()

    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.scene?.scaleMode = .aspectFit
        self.physicsWorld.contactDelegate = self
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 200)
        scoreLabel.zPosition = 2
        scoreLabel.text = "score : \(score) "
        scoreLabel.fontSize = 50
        self.addChild(scoreLabel)
        
        hscoreLabel.fontName = "Helvetica"
        hscoreLabel.fontColor = .white
        hscoreLabel.position = CGPoint(x: 200, y: -600)
        hscoreLabel.zPosition = 2
        hscoreLabel.text = "High Score : 0"
        hscoreLabel.fontSize = 50
        self.addChild(hscoreLabel)
        
        
        

        //BALL
        
        ball = childNode(withName: "ball") as! SKSpriteNode
        let ballTexture = SKTexture(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballTexture.size().width / 15)
        
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.restitution = 1
        ballPosition = ball.position
        
        ball.physicsBody?.categoryBitMask = ColliderType.ball.rawValue
        ball.physicsBody?.contactTestBitMask = ColliderType.ball.rawValue
        ball.physicsBody?.collisionBitMask = ColliderType.wood.rawValue

        //WOOD
        
        wood = childNode(withName: "wood") as! SKSpriteNode
        let woodTexture = SKTexture(imageNamed: "wood")
        let size = CGSize(width: woodTexture.size().width / 10.5, height: woodTexture.size().height / 10)
        wood.physicsBody = SKPhysicsBody(rectangleOf: size)
        wood.physicsBody?.isDynamic = false
        wood.physicsBody?.affectedByGravity = false
        wood.physicsBody?.collisionBitMask = ColliderType.ball.rawValue
        
        //STONE
        stone = childNode(withName: "stone") as! SKSpriteNode
        let stoneTexture = SKTexture(imageNamed: "stone")
        let stonesize = CGSize(width: stoneTexture.size().width*1.45, height: stoneTexture.size().height/9.5)
        stone.physicsBody = SKPhysicsBody(rectangleOf: stonesize)
        stone.physicsBody?.collisionBitMask = ColliderType.ball.rawValue
        
    }

  
        
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node == ball && contact.bodyB.node == wood) ||
            (contact.bodyA.node == wood && contact.bodyB.node == ball) {
            score = score + 1
            scoreLabel.text = "Score : \(score)"
            
            let woodWidth = wood.size.width
            
            
            let contactPoint = contact.contactPoint.x
            let woodCenter = wood.position.x
            
            
            let distanceFromCenter = contactPoint - woodCenter
            
           
            let maxHorizontalSpeed: CGFloat = 800.0
            
            
            let horizontalSpeed = (distanceFromCenter / (woodWidth / 2)) * maxHorizontalSpeed
            
            
            var verticalSpeed: CGFloat = 2000.0
            if score > 10 {
                
                verticalSpeed = 2800
            }
            if score > 20 {
                verticalSpeed = 3600
            }
            if score > 50 {
                verticalSpeed = 5000
            }
            
            
            ball.physicsBody?.velocity = CGVector(dx: horizontalSpeed, dy: verticalSpeed)
        }
        if (contact.bodyA.node == ball && contact.bodyB.node == stone) ||
            (contact.bodyA.node == stone && contact.bodyB.node == ball) {
            gameStart = false
        }
    }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if gameStart == true{
            ball.physicsBody?.affectedByGravity = true
            if let touch = touches.first {
                let location = touch.location(in: self)
                wood.position = CGPoint(x: location.x, y: wood.position.y)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameStart = true
        if gameStart == true{
            if let touch = touches.first {
                let location = touch.location(in: self)
                wood.position = CGPoint(x: location.x, y: wood.position.y)
            }

        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func update(_ currentTime: TimeInterval) {
        
        if gameStart == false{
            if score >= hscore {
                hscore = score
            }
            hscoreLabel.text = "High Score : \(hscore) "
                
            score = 0
            scoreLabel.text = "score : \(score) "
            ball.physicsBody?.velocity.dy = 0
            ball.physicsBody?.velocity.dx = 0
            ball.physicsBody?.angularVelocity = 0
            ball.position = ballPosition
            ball.physicsBody?.affectedByGravity = false
           
        }
            

    }
}
