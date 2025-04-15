//
//  SettingsViewController.swift
//  MyContactList
//
//  Created by Amishi Patel on 4/1/25.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!

    let sortOrderItems: [String] = ["ContactName", "City", "Birthday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        pckSortField.dataSource = self
        pckSortField.delegate = self
    }

    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }

    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }

    // Optional: Handle picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = sortOrderItems[row]
        print("Selected sort field: \(selectedItem)")
    }
}
