//
//  AddViewController.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bellButton: UIBarButtonItem!
    
    public var completion: ((String, Date?) -> Void)?
    
    var bellButtonIsOn = false
    
    let placeHolder = "Enter text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = placeHolder
        textView.textColor = UIColor.darkGray
        textView.delegate = self
        
        datePicker.isHidden = true
        datePicker.minimumDate = Date()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        if let titleText = textView.text, textView.text != placeHolder{
            
            var targetDate:Date? = datePicker.date
            print("DatePicker - \(String(describing: targetDate))")
            if datePicker.isHidden == true{
                targetDate = nil
            }
            completion?(titleText, targetDate)
        }
    }
    
    @IBAction func bellButtonPressed(_ sender: UIBarButtonItem) {
        
        bellButtonIsOn = !bellButtonIsOn
        bellButton.image = bellButtonIsOn ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell")
        datePicker.isHidden = !bellButtonIsOn
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension AddViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 100
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Text"
            textView.textColor = UIColor.darkGray
        }
    }
}
