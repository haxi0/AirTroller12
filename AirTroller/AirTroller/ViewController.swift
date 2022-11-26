//
//  ViewController.swift
//  AirTroller
//
//  Created by Анохин Юрий on 25.11.2022.
//

import UIKit

class ViewController: UIViewController {
    var trollController = TrollController(sharedURL: Bundle.main.url(forResource: "Trollface", withExtension: "png")!, rechargeDuration: 1)
    @IBOutlet weak var startTrolling: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trollController.startBrowser()
    }
    
    @IBAction func SliderChanged(_ sender: UISlider) {
        trollController.rechargeDuration = TimeInterval(sender.value)
    }
    
    @IBAction func ItsTrollingTime(_ sender: Any) {
        trollController.isRunning.toggle()
        self.startTrolling.setTitle("Trolling...", for: UIControl.State.normal)
        if trollController.isRunning {
            trollController.startTrolling(shouldTrollHandler: { person in
                return true // troll everyone, muhahahhaah
            }, eventHandler: { event in
                switch event {
                case .operationEvent(let event1):
                    if event1 == .canceled || event1 == .finished || event1 == .blocked {
                        UISelectionFeedbackGenerator().selectionChanged()
                    }
                case .cancelled:
                    UISelectionFeedbackGenerator().selectionChanged()
                }
            })
        } else {
            trollController.stopTrollings()
        }
    }
    
    @IBAction func ItsNotTrollingTime(_ sender: Any) {
        trollController.isRunning = false
        self.startTrolling.setTitle("Start Trolling", for: UIControl.State.normal)
    }
    
}
