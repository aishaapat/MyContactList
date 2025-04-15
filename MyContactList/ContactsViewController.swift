//
//  ContactsViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {
    func dataChanged(date: Date) {
        if currentContact == nil{
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.birthday = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblBirthdaye.text = formatter.string(from: date)
    }
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblBirthdaye: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBAction func changeEditMode(_ sender: Any)
    {
 
    }
    
    @IBOutlet weak var scrollView: UIScrollView!  // Changed to UIScrollView

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyBoardNotifications()
        sgmtEditMode.addTarget(self, action: #selector(changeEditMode(sender:)), for: .valueChanged)
        let textFields: [UITextField] = [txtName,txtAddress,txtCity,txtState,txtZip,txtPhone,txtCell,txtEmail]
        for textfield in textFields {
            textfield.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)

        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }

        switch textField {
        case txtName:
            currentContact?.contactName = textField.text
        case txtAddress:
            currentContact?.streetAddress = textField.text
        case txtCity:
            currentContact?.city = textField.text
        case txtState:
            currentContact?.state = textField.text
        case txtZip:
            currentContact?.zipCode = textField.text
        case txtPhone:
            currentContact?.phoneNumber = textField.text
        case txtCell:
            currentContact?.cellNumber = textField.text
        case txtEmail:
            currentContact?.email = textField.text
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unregisterKeyBoardNotifications()
    }

    func registerKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardSize = keyboardFrame.cgRectValue.size
            var contentInset = scrollView.contentInset
            contentInset.bottom = keyboardSize.height
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = scrollView.contentInset
        contentInset.bottom = 0
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // adding button stuff for birthday now
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeEditMode(sender: Any) {
        let textFields: [UITextField] =
        [txtZip, txtCell, txtCity, txtName, txtEmail, txtPhone, txtState, txtAddress]

        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = .none
            }
            btnChange.isHidden = true
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = .roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveContact))
        }
    }
    
    @objc func saveContact(){
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "sequeContactDate"){
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }

}

