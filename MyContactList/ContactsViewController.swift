//
//  ContactsViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
    
    @IBAction func changePicture(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        if let image = info[.editedImage] as? UIImage{
            imgContactPicture.contentMode = .scaleAspectFit
            if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
            }
            currentContact?.image = image.jpegData(compressionQuality: 1.0)
            imgContactPicture.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var imgContactPicture: UIImageView!
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
    
    @IBOutlet weak var scrollView: UIScrollView!  // Changed to UIScrollView

    override func viewDidLoad(){
        super.viewDidLoad()
        if currentContact != nil {
            txtName.text = currentContact!.contactName
            txtAddress.text = currentContact!.streetAddress
            txtCity.text = currentContact!.city
            txtState.text = currentContact!.state
            txtZip.text = currentContact!.zipCode
            txtPhone.text = currentContact!.phoneNumber
            txtCell.text = currentContact!.cellNumber
            txtEmail.text = currentContact!.email
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentContact!.birthday != nil {
                lblBirthdaye.text = formatter.string(from: currentContact!.birthday!)
            }
            if let imageData = currentContact?.image {
                imgContactPicture.image = UIImage(data: imageData)
            }

        }
        
        changeEditMode(self)
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtPhone, txtCell, txtEmail]
        
        for textfield in textFields{
            textfield.addTarget(self,
                action: #selector(self.textFieldDidEndEditing(_:)),
                for: .editingDidEnd)

            
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
        
    }

  /**  func registerKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    } */
    
  /**  func unregisterKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self)
    } */
    
  /** @objc func keyboardDidShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardSize = keyboardFrame.cgRectValue.size
            var contentInset = scrollView.contentInset
            contentInset.bottom = keyboardSize.height
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    } */

   /** @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = scrollView.contentInset
        contentInset.bottom = 0
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    */
    // adding button stuff for birthday now
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
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

