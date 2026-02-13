//
//  ViewController.swift
//  StudentPerformanceIndex
//
//  Created by GEU on 13/02/26.
//

import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var hoursStudiedLabel: UILabel!
    @IBOutlet weak var previousScoreValue: UITextField!
    @IBOutlet weak var extraCurricularSwitch: UISwitch!
    @IBOutlet weak var sleepHoursLabel: UILabel!
    @IBOutlet weak var qpSolvedLabel: UILabel!
    @IBOutlet weak var hoursStudiedStepper: UIStepper!
    @IBOutlet weak var sleepHoursStepper: UIStepper!
    @IBOutlet weak var questionPaperSolvedStepper: UIStepper!
    
    @IBOutlet weak var performanceIndexLabel: UILabel!
    
    private var hoursStudied = 1
        private var sleepHours = 1
        private var qpSolved = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                updateUI()
    }

        // MARK: - UI Updates
        private func updateUI() {
            hoursStudiedLabel.text = "\(hoursStudied)"
            sleepHoursLabel.text = "\(sleepHours)"
            qpSolvedLabel.text = "\(qpSolved)"
        }

    @IBAction func hoursStudiedAction(_ sender: UIStepper) {
        hoursStudied = Int(sender.value)
            updateUI()
    }
    
    @IBAction func extraCurricularAction(_ sender: Any) {
    }
    @IBAction func sleepHoursAction(_ sender: UIStepper) {
        sleepHours = Int(sender.value)
            updateUI()
    }
    
    @IBAction func qpSolvedAction(_ sender: UIStepper) {
        qpSolved = Int(sender.value)
            updateUI()
    }
    
    @IBAction func calculateAction(_ sender: Any) {
        guard
                let prevScoreText = previousScoreValue.text,
                let previousScore = Int64(prevScoreText)
            else {
                performanceIndexLabel.text = "Invalid Input"
                return
            }

            let extracurricular = extraCurricularSwitch.isOn ? "Yes" : "No"

            do {
                let model = try GEUPerformanceIndexPrediction_1(
                    configuration: MLModelConfiguration()
                )

                let prediction = try model.prediction(
                    Hours_Studied: Int64(hoursStudied),
                    Previous_Scores: previousScore,
                    Extracurricular_Activities: extracurricular,
                    Sleep_Hours: Int64(sleepHours),
                    Sample_Question_Papers_Practiced: Int64(qpSolved)
                )

                performanceIndexLabel.text =
                    String(format: "%.2f", prediction.Performance_Index)

            } catch {
                performanceIndexLabel.text = "Prediction Failed"
                print(error)
            }
//        let resultAlert = UIAlertController(title: "Result", message: performanceIndexLabel.text, preferredStyle: .alert)
//        resultAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(resultAlert, animated: true, completion: nil)
    }
    
    
}

