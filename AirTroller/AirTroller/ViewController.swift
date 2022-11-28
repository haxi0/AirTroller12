//
//  ViewController.swift
//  AirTroller
//
//  Created by Анохин Юрий on 25.11.2022.
//

import UIKit

class ViewController: UIViewController {
    var trollController = TrollController(sharedURL: Bundle.main.url(forResource: "Trollface", withExtension: "png")!, rechargeDuration: 0.5)
    @IBOutlet weak var startTrolling: UIButton!
    @IBOutlet weak var stopTrolling: UIButton!
    @IBOutlet weak var people: UITextView!
    
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
        people.text = trollController.people.map { $0.displayName ?? "Unknown" } .joined(separator: "\n")
        self.stopTrolling.isUserInteractionEnabled = true
        self.stopTrolling.alpha = 1.0
        self.startTrolling.isUserInteractionEnabled = false
        self.startTrolling.alpha = 0.5
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
        people.text = ""
        self.stopTrolling.isUserInteractionEnabled = false
        self.stopTrolling.alpha = 0.5
        self.startTrolling.isUserInteractionEnabled = true
        self.startTrolling.alpha = 1.0
        self.startTrolling.setTitle("Start Trolling", for: UIControl.State.normal)
    }
    
}
