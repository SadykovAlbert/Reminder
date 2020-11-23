//
//  AddViewController.swift
//  Reminder
//
//  Created by Albert on 11.11.2020.
//  Copyright © 2020 AlbertSadykov. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    //@IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //@IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bellButton: UIBarButtonItem!
    
    public var completion: ((String, Date?) -> Void)?

     
    var bellButtonIsOn = false

    let placeHolder = "Enter text"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //textView
    
        
        textView.text = placeHolder
        textView.textColor = UIColor.darkGray
        
        textView.delegate = self
        //textView.text.place
        //switchButton.isOn = false
        datePicker.isHidden = true
        datePicker.minimumDate = Date()
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //if let titleText = textField.text, !titleText.isEmpty {
        if let titleText = textView.text, textView.text != placeHolder{

            var targetDate:Date? = datePicker.date
            print("DatePicker - \(String(describing: targetDate))")
            if datePicker.isHidden == true{
                targetDate = nil
            }
            completion?(titleText, targetDate)
        }
    }
//    @IBAction func switchAction(_ sender: UISwitch) {
//        datePicker.isHidden = !switchButton.isOn
//    }
    @IBAction func bellButtonPressed(_ sender: UIBarButtonItem) {
        
        bellButtonIsOn = !bellButtonIsOn
        bellButton.image = bellButtonIsOn ? UIImage(systemName: "bell.fill") : UIImage(systemName: "bell")
        datePicker.isHidden = !bellButtonIsOn
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
    }
    
}


/*
 


 override func viewDidLoad() {
     super.viewDidLoad()
     titleField.delegate = self
     bodyField.delegate = self
     navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
 }

 @objc func didTapSaveButton() {
     if let titleText = titleField.text, !titleText.isEmpty,
         let bodyText = bodyField.text, !bodyText.isEmpty {

         let targetDate = datePicker.date

         completion?(titleText, bodyText, targetDate)

     }
 }

 func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     return true
 }
 
 
 */

extension AddViewController : UITextViewDelegate{
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 100   // 100 Limit Value
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
