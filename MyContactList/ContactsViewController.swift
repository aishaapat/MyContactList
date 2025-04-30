//
//  ContactsViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit
import CoreData
import AVFoundation


class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imgContactPicture: UIImageView!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblBirthdaye: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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

    
    @IBOutlet weak var changeButton: UIButton!
    
    
    @IBAction func changePicture(_ sender: UIButton) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != AVAuthorizationStatus.authorized
            {
            let alertController = UIAlertController(title: "Camera Access Denied", message: "In order to take pictures, allow the app to access the camera in the settings", preferredStyle: .alert)
            
            let actionSettings = UIAlertAction(title: "Open Settings", style: .default) {
                action in
                self.openSettings()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(actionSettings)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
        else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraController = UIImagePickerController()
                cameraController.sourceType = .camera
                cameraController.cameraCaptureMode = .photo
                cameraController.delegate = self
                cameraController.allowsEditing = true
                self.present(cameraController, animated: true, completion: nil)
            }
        }
        
    }
    
    func openSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?

        if let edited = info[.editedImage] as? UIImage {
            selectedImage = edited
        } else if let original = info[.originalImage] as? UIImage {
            selectedImage = original
        }

        if let image = selectedImage {
            imgContactPicture.contentMode = .scaleAspectFit
            imgContactPicture.image = image

            if currentContact == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }

            currentContact?.image = image.jpegData(compressionQuality: 0.8)
        }

        dismiss(animated: true, completion: nil)
    }


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

    override func viewDidLoad()
    {
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
            if let imageData = currentContact?.image {
                imgContactPicture.image = UIImage(data: imageData)
            }
            if currentContact!.birthday != nil {
                lblBirthdaye.text = formatter.string(from: currentContact!.birthday!)
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
    
    @objc func callPhone(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let number = txtPhone.text, !number.isEmpty else { return }
            if let url = URL(string: "tel://\(number)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                print("Calling phone \(url)")
            }
        }
    }

}

