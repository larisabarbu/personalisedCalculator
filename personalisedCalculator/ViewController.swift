//
//  ViewController.swift
//  personalisedCalculator
//
//  Created by Larisa Barbu on 18/03/2016.
//  Copyright © 2016 Larisa Barbu. All rights reserved.
//

import UIKit
import AVFoundation   //imports sound

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Substract = "-"
        case Add = "+"
        case Empty = "Empty"
    }

    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    //initiallises the sound
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //When user double taps the counter label, app will CLEAR
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onClear:")
        
                doubleTap.numberOfTapsRequired = 2
                doubleTap.numberOfTouchesRequired = 1
        
                self.outputLbl.addGestureRecognizer(doubleTap)
                self.outputLbl.userInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        //loads the URL of the sound
        
        do {
                try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
                btnSound.prepareToPlay()
        } catch let err as NSError {
                print(err.debugDescription)
        } //assigned an Audio Player to the button
        
        
    }

    @IBAction func numberPressed(btn: UIButton!) {
        btnSound.play()
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }

    @IBAction func onSubstractPressed(sender: AnyObject) {
        processOperation(Operation.Substract)
    }
    
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            
            //Run some math
            
            // An user selected an operator, an then another operator
            //without selecting a number
            
            if runningNumber != "" {
               
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Substract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                
                leftValStr = result
                outputLbl.text = result
                
            }
            
            currentOperation = op
            // this stores the sum(e.g 5+6), in order to add more to it.
            
        } else {
            //This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
            
        }
        
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func onClear(uiGestureRecognizer: UIGestureRecognizer){
        
        clear()
    }
    
    func clear(){
        
        currentOperation = Operation.Empty
        
        result = ""
        runningNumber = ""
        
        leftValStr = ""
        rightValStr = ""
        
        outputLbl.text = "0"
    }
}

