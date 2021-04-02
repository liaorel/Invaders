//
//  GameViewController.swift
//  labor1
//
//  Created by Разработчик on 01/04/2021.
//  Copyright © 2021 Developer. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var RightButton: UIButton!
    @IBOutlet weak var LeftButton: UIButton!
    
  @IBOutlet weak var gameOver: UILabel!
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBOutlet weak var score: UILabel!
  @IBOutlet weak var ExitButton: UIButton!
    
    
    private let roketa = UIImage (named:"roketa")
    private var roketaView = UIImageView ()
    
    private let enemy = UIImage (named:"enemy")
    var enemyView = [UIImageView]()
   var aliveEnemies = 40
    
    var buttonShoot: UIButton!
    
    private var rightDirection = true
    private var stepDirection = 1
    private var shot = 40
    var roketaAttack = 40
    var ourBullets = [UIImageView]()

  var enemyAttack = 50
  var enemyBullets = [UIImageView]()
  var health = 1
  var currentScore = 0
    
    var t : Timer?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let LeftButtonImage = UIImage(named: "next copy")
        let RightButtonImage = UIImage(named: "next")
      
       
        
        LeftButton.setImage(LeftButtonImage, for: .normal)
        RightButton.setImage(RightButtonImage, for: .normal)
        

        createRoketa()
        createEnemy()
        buttonTargets()
        score.isHidden = true
        scoreLabel.isHidden = true
        gameOver.isHidden = true
        ExitButton.isHidden = true
        self.ExitButton.isEnabled = false
       
        t = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(draw), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    
    private func createRoketa () {
        roketaView = UIImageView (image: roketa)
        roketaView.frame = CGRect (x:0, y:0, width: 100, height: 100)
        roketaView.center = self.view.center
        roketaView.center.y = LeftButton.center.y-100
        self.view.addSubview(roketaView)

    }
    
    @objc func draw()  {
        
        enemiesAttack()
        drawAttack()
        
    }
    
    private func buttonTargets(){
        self.LeftButton.addTarget(self, action: #selector(moveShipLeft(sender:)), for: .touchDown)
        self.RightButton.addTarget(self, action: #selector(moveShipRight(sender:)), for: .touchDown)
        self.ExitButton.addTarget(self, action: #selector(goToMenu(sender:)), for: .touchUpInside)
    }

    private func createEnemy () {
        for i in 0..<40 {
            let enemyViewIm = UIImageView (image: enemy)
            if (i < 8) {
                enemyViewIm.frame = CGRect(x: (i)*60+5, y: 100, width: 40, height: 40)
            } else if (i < 16) {
                enemyViewIm.frame = CGRect(x: (i-8)*60+5, y: 150, width: 40, height: 40)
            } else if (i < 24) {
                enemyViewIm.frame = CGRect(x: (i-16)*60+5, y: 200, width: 40, height: 40)
            } else if (i < 32) {
                enemyViewIm.frame = CGRect(x: (i-24)*60+5, y: 250, width: 40, height: 40)
            } else {
                enemyViewIm.frame = CGRect(x: (i-32)*60+5, y: 300, width: 40, height: 40)
            }
            
            self.enemyView.append(enemyViewIm)
            self.view.addSubview(enemyView[i])
            enemyView[i].isHidden = false
        }
            
    }
    
    
    func drawAttack() {
        roketaAttack += 1
        Shoot()
        
        
        checkForDeath()
        
        
    }
  
  func enemiesAttack(){
    enemyAttack += 1
    
    if enemyAttack >= 60 {
      let randx = Int.random(in: 0...4)
      let selectedEnemy = enemyView[randx]
      if !selectedEnemy.isHidden {
        let myView = CGRect(x: selectedEnemy.frame.origin.x + selectedEnemy.frame.width * 0.45, y: selectedEnemy.frame.origin.y + selectedEnemy.frame.height * 0.3, width: selectedEnemy.frame.width * 0.5, height: selectedEnemy.frame.height * 0.5)
        let newEnemyBullet = UIImageView(frame: myView)
        newEnemyBullet.image = #imageLiteral(resourceName: "core")
        view.addSubview(newEnemyBullet)
        enemyBullets.append(newEnemyBullet)
        enemyAttack = 0
      }
    }
    
    for (number, item) in enemyBullets.enumerated() {
      item.frame.origin.y += 5
      if item.frame.origin.y > item.frame.height + view.frame.height {
        enemyBullets[number].removeFromSuperview()
        enemyBullets.remove(at: number)
      }
    }
    
    
  }
  
  func checkForDeath() {
    if enemyView[0].frame.origin.y + enemyView[0].frame.height > roketaView.frame.origin.y {
      die()
    }
    
    for (number, item) in enemyBullets.enumerated() {
      item.frame.origin.y += 5
      if item.frame.origin.y > item.frame.height + view.frame.height {
        enemyBullets[number].removeFromSuperview()
        enemyBullets.remove(at: number)
      }
      if (item.frame.origin.y - roketaView.frame.height*0.3 > roketaView.frame.origin.y){
        if (item.frame.intersects(roketaView.frame)) {
          enemyBullets[number].removeFromSuperview()
          enemyBullets.remove(at: number)
          health-=1
          if (health==0) {
            die()
          }
          
        }
      }
    }
    
  }
  
  func die() {
    aliveEnemies = 15
    score.text = String(currentScore)
    score.isHidden = false
    scoreLabel.isHidden = false
    LeftButton.isEnabled = false
    RightButton.isEnabled = false
    gameOver.isHidden = false
    ExitButton.isHidden = false
    self.ExitButton.isEnabled = true
    t?.invalidate()
  }
    
    private func Shoot(){
        if roketaAttack > 40 {
            let myView = CGRect(x: roketaView.frame.origin.x + roketaView.frame.width * 0.45, y: roketaView.frame.origin.y-roketaView.frame.height * 0.3, width: roketaView.frame.width * 0.1, height: roketaView.frame.height * 0.5)
            let newOurBullet = UIImageView(frame: myView)
            newOurBullet.image = #imageLiteral(resourceName: "bullet")
            view.addSubview(newOurBullet)
            ourBullets.append(newOurBullet)
            roketaAttack = 0
        }
        let enemyPos = enemyView[39].frame.origin.y + enemyView[39].frame.height
         outer: for (number, item) in ourBullets.enumerated(){
             item.frame.origin.y -= 10
             if item.frame.origin.y < -150 {
                 ourBullets[number].removeFromSuperview()
                 ourBullets.remove(at: number)
             } else {
                 if enemyPos >= item.frame.origin.y {
                     inner : for i in stride(from: 39, to: -1, by: -1) {
                         
                             if (item.frame.intersects(enemyView[i].frame) && enemyView[i].isHidden==false) {
                                 ourBullets[number].removeFromSuperview()
                                 ourBullets.remove(at: number)
                                 enemyView[i].isHidden = true
                                 aliveEnemies -= 1
                                 currentScore += 1
                              
                              if aliveEnemies == 0 {
                                t?.invalidate()
                                aliveEnemies = 40
                                score.text = String(currentScore)
                                score.isHidden = false
                                scoreLabel.isHidden = false
                                
                                ExitButton.isHidden = false
                                
                                LeftButton.isEnabled = false
                                RightButton.isEnabled = false
                                self.ExitButton.isEnabled = true
                                 
                                     break outer
                                 }
                                 break inner
                            
                         }
                     }
                 }
             }
      }
    }
    @objc private func shootTimer(sender: UIButton){
        self.Shoot()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(shootTimer(sender:)), userInfo: nil, repeats: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMenu"{
            if let vc = segue.destination as? ViewController{
                if let temp = sender as? Int{
                    vc.score = temp
                }
            }
        }
        
    }
    @objc func goToMenu(sender: UIButton){
        performSegue(withIdentifier: "back", sender: self.currentScore)
    }
    
    @objc private func moveShipLeft(sender: UIButton){
        if LeftButton.isHighlighted && roketaView.frame.minX>self.view.bounds.minX{
            roketaView.center = CGPoint(x: roketaView.center.x-3, y: roketaView.center.y)
            perform(#selector(moveShipLeft(sender:)), with: nil, afterDelay: 0.015)
        }
    }
 
    @objc private func moveShipRight(sender: UIButton){
        if RightButton.isHighlighted && roketaView.frame.maxX<self.view.bounds.width{
            roketaView.center = CGPoint(x: roketaView.center.x+3, y: roketaView.center.y)
            perform(#selector(moveShipRight(sender:)), with: nil, afterDelay: 0.015)
        }
    }
    
}


