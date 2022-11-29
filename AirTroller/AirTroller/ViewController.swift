//
//  ViewController.swift
//  AirTroller
//
//  Created by Анохин Юрий on 25.11.2022.
//

import UIKit

class ViewController: UIViewController {
    var trollController = TrollController(sharedURL: Bundle.main.url(forResource: "Trollface", withExtension: "png")!, rechargeDuration: 0.5)
    var totalAirDrops: Int = 0
    @IBOutlet weak var totalAirDropsText: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var startTrolling: UIButton!
    @IBOutlet weak var stopTrolling: UIButton!
    @IBOutlet weak var people: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        trollController.startBrowser()
    }
    
    @IBAction func SliderChanged(_ sender: UISlider) {
        let roundedValue = round(sender.value / 0.5) * 0.5
        sender.value = roundedValue
        trollController.rechargeDuration = TimeInterval(sender.value)
        self.seconds.text = String(sender.value)
    }
    
    @IBAction func ItsTrollingTime(_ sender: Any) {
        self.startTrolling.isUserInteractionEnabled = false
        self.startTrolling.alpha = 0.5
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.trollController.isRunning.toggle()
            self.people.text = self.trollController.people.map { $0.displayName ?? "Unknown" } .joined(separator: "\n")
            self.stopTrolling.isUserInteractionEnabled = true
            self.stopTrolling.alpha = 1.0
            self.startTrolling.setTitle("Trolling...", for: UIControl.State.normal)
            if self.trollController.isRunning {
                self.trollController.startTrolling(shouldTrollHandler: { person in
                    return true // troll everyone, muhahahhaah
                }, eventHandler: { event in
                    switch event {
                    case .operationEvent(let event1):
                        if event1 == .canceled || event1 == .finished || event1 == .blocked {
                            self.totalAirDrops += 1
                            self.totalAirDropsText.text = "Total AirDrops: \(self.totalAirDrops)"
                            UISelectionFeedbackGenerator().selectionChanged()
                        }
                    case .cancelled:
                        self.totalAirDrops += 1
                        self.totalAirDropsText.text = "Total AirDrops: \(self.totalAirDrops)"
                        UISelectionFeedbackGenerator().selectionChanged()
                    }
                })
            } else {
                self.trollController.stopTrollings()
            }
        }
    }
    
    @IBAction func ItsNotTrollingTime(_ sender: Any) {
        trollController.isRunning = false
        self.stopTrolling.isUserInteractionEnabled = false
        self.stopTrolling.alpha = 0.5
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            self.people.text = ""
            self.totalAirDropsText.text = ""
            self.startTrolling.isUserInteractionEnabled = true
            self.startTrolling.alpha = 1.0
            self.startTrolling.setTitle("Start Trolling", for: UIControl.State.normal)
          }
    }
    
}
