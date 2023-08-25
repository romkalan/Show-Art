//
//  ViewController.swift
//  Show Art
//
//  Created by Roman Lantsov on 16.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero // запоминает последнюю нарисованную точку на холсте (используется для отрисовки непрерывного мазка)
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false // используется когда мазок непрерывен
    
    let colors = Colors.shared.getColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.delegate = self
        settingsVC.brush = brushWidth
        settingsVC.opacity = opacity
        settingsVC.red = red
        settingsVC.green = green
        settingsVC.blue = blue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Передача изображения из tempImage в mainImage
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(
            in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height),
            blendMode: .normal,
            alpha: 1.0
        )
        tempImageView.image?.draw(
            in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height),
            blendMode: .normal,
            alpha: opacity
        )
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    @IBAction func reset(sender: AnyObject) {
        mainImageView.image = nil
    }

    @IBAction func share(_ sender: UIButton) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.draw(in: CGRect(
            x: 0,
            y: 0,
            width: mainImageView.frame.size.width,
            height: mainImageView.frame.size.height
        ))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        activityVC.popoverPresentationController?.sourceView = sender
        activityVC.popoverPresentationController?.sourceRect = CGRect(
            x: 0, y: 0, width: 200, height: 50
        )
        
        present(activityVC, animated: true)
    }
    
    
    @IBAction func widthPressed(_ sender: AnyObject) {
        if sender.tag == 0 {
            brushWidth = 1
        } else if sender.tag == 1 {
            brushWidth = 10
        }
        
    }
    
    
    @IBAction func pencilPressed(sender: AnyObject) {
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        (red, green, blue) = colors[index]
        
        // Erraser
        if index  == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempImageView.image?.draw(in: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: view.frame.size.height
        ))
        
        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(CGColor(red: red, green: green, blue: blue, alpha: 1.0))
        context.setBlendMode(CGBlendMode.normal)
        
        context.strokePath()
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        
        UIGraphicsEndImageContext()
    }
}

extension ViewController: SettingsViewControllerDelegate {
    func settingsViewControllerPresent(settingsViewController: SettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }
}

