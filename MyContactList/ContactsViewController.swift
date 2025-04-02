//
//  ContactsViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!  // Changed to UIScrollView

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyBoardNotifications()
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
}

