//
//  ViewController.swift
//  CircleLoadingAnimation
//
//  Created by Prato Das on 2017-12-09.
//  Copyright © 2017 Prato Das. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    

    
    let shapeLayer = CAShapeLayer()
    
    var pulsatingLayer: CAShapeLayer!

    
    
    let primaryColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1.0)
    

    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        // let's start by drawing a circle


        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = 5
        pulsatingLayer.fillColor = primaryColor.withAlphaComponent(0.5).cgColor
        pulsatingLayer.lineCap = kCALineCapRound
        pulsatingLayer.position = view.center
        view.layer.addSublayer(pulsatingLayer)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = primaryColor.withAlphaComponent(0.1).cgColor
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        

        
        animatePulsatingLayer(toValue: 1)
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = primaryColor.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.strokeEnd = 0
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        
        view.addSubview(urlField)
        
        urlField.frame = CGRect(x: 8, y: 44, width: view.frame.width - 16, height: 44)
        
        var ourTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(addPulse), userInfo: nil, repeats: true)
        
        
//        //init toolbar
//        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
//        //create left side empty space so that done button set on right side
//        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
//        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
//        toolbar.setItems([flexSpace, doneBtn], animated: false)
//        toolbar.sizeToFit()
//        //setting toolbar as inputAccessoryView
//        self.urlField.inputAccessoryView = toolbar
//        self.urlField.inputAccessoryView = toolbar
//
        
    }
    
    private func animatePulsatingLayer(toValue: Float) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = toValue
        animation.duration = 0.8
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
        
    }
    
    var urlString = ""
    
    private func beginDownloadingFile() {
        self.view.endEditing(true)
        print("Attempting to download file")
        shapeLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        if urlField.text != nil {
            urlString = urlField.text!
        } else { return }

        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished downloading file")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        ViewController.already = totalBytesWritten
        ViewController.expected = totalBytesExpectedToWrite
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))"
            self.shapeLayer.strokeEnd = percentage
        }
    }
    
    
    static var already: Int64!
    static var expected: Int64!
    
    @objc func addPulse() {
        DispatchQueue.main.async {
            if ViewController.already != nil && ViewController.expected != nil {
                self.animatePulsatingLayer(toValue: Float(CGFloat(ViewController.already) / CGFloat(ViewController.expected)) + 1)
            }
        }
    }
    var ourTimer: Timer?
    
    
    @objc private func handleTap() {
        beginDownloadingFile()
    }
    
    
    let percentageLabel: UILabel = {
        let pl = UILabel()
        pl.textAlignment = .center
        pl.text = "Start"
        pl.font = UIFont.boldSystemFont(ofSize: 32)
        pl.translatesAutoresizingMaskIntoConstraints = false
        pl.clipsToBounds = true
        pl.textColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 0.5)
        pl.backgroundColor = UIColor.black
        return pl
        
    }()
    
    let urlField: UITextField = {
        let urlField = UITextField()
        urlField.translatesAutoresizingMaskIntoConstraints = false
        urlField.clipsToBounds = true
        urlField.backgroundColor = UIColor.black
        urlField.textColor = UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 0.5)
        urlField.textAlignment = .center
        return urlField
    }()
    
    


}

