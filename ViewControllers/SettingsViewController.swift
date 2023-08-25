//
//  SettingsViewController.swift
//  Show Art
//
//  Created by Roman Lantsov on 16.08.2023.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerPresent(settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet var brushSlider: UISlider!
    @IBOutlet var opacitySlider: UISlider!
    @IBOutlet var redColorSlider: UISlider!
    @IBOutlet var greenColorSlider: UISlider!
    @IBOutlet var blueColorSlider: UISlider!
    
    @IBOutlet var brushImageView: UIImageView!
    
    @IBOutlet var brushValueLabel: UILabel!
    @IBOutlet var opacityValueLabel: UILabel!
    
    @IBOutlet var redColorValueLabel: UILabel!
    @IBOutlet var greenColorValueLabel: UILabel!
    @IBOutlet var blueColorValueLabel: UILabel!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        brushSlider.value = Float(brush)
        brushValueLabel.text = String(format: "%.2f", brush.native)
        opacitySlider.value = Float(opacity)
        opacityValueLabel.text = String(format: "%.2f", opacity.native)
        
        redColorSlider.value = Float(red * 255)
        redColorValueLabel.text = String(format: "%d", Int(redColorSlider.value))
        greenColorSlider.value = Float(green * 255)
        greenColorValueLabel.text = String(format: "%d", Int(greenColorSlider.value))
        blueColorSlider.value = Float(blue * 255)
        blueColorValueLabel.text = String(format: "%d", Int(blueColorSlider.value))
        
        drawPreview()
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        self.delegate?.settingsViewControllerPresent(settingsViewController: self)
    }

    @IBAction func colorChanged(sender: UISlider) {
        red = CGFloat(redColorSlider.value / 255.0)
        redColorValueLabel.text = String(format: "%d", Int(redColorSlider.value))
        
        green = CGFloat(greenColorSlider.value / 255.0)
        greenColorValueLabel.text = String(format: "%d", Int(greenColorSlider.value))
        
        blue = CGFloat(blueColorSlider.value / 255.0)
        blueColorValueLabel.text = String(format: "%d", Int(blueColorSlider.value))
        
        drawPreview()
    }

    @IBAction func sliderChanged(sender: UISlider) {
        if sender == brushSlider {
            brush = CGFloat(sender.value)
            brushValueLabel.text = String(format: "%.2f", brush.native)
        } else {
            opacity = CGFloat(sender.value)
            opacityValueLabel.text = String(format: "%.2f", opacity.native)
        }
        
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(brushImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setLineCap(.round)
        context.setLineWidth(brush)
        context.setStrokeColor(red: red, green: green, blue: blue, alpha: opacity)
        context.move(to: CGPoint(
            x: brushImageView.frame.size.width / 2,
            y: brushImageView.frame.size.height / 2
        ))
        context.addLine(to: CGPoint(
            x: brushImageView.frame.size.width / 2,
            y: brushImageView.frame.size.height / 2
        ))
        context.strokePath()
        
        brushImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }

}
