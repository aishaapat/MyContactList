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

    let sortOrderItems: Array<String> = ["contactName", "city", "birthday", "email"]

    override func viewDidLoad() {
        super.viewDidLoad()
        pckSortField.dataSource = self
        pckSortField.delegate = self
        let device = UIDevice.current
        print("Device info: \n Name: \(device.name) \n Model: \(device.model)")
        let orientation: String
        switch device.orientation{
        case .faceDown:
            orientation = "Face down"
        case .faceUp:
            orientation = "Face up"
        case .portrait:
            orientation = "Portrait"
        case .landscapeLeft:
            orientation = "Landscape left"
        case .unknown:
            orientation = "Unknown"

        case .portraitUpsideDown:
            orientation = "Portrait upside down"
        case .landscapeRight:
            orientation = "Landscape right"
        @unknown default:
            fatalError( "Unknown orientation")
        
        }
        print ("Orientation: \(orientation)")
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
        let settings = UserDefaults.standard
        settings.set(selectedItem ,forKey: Constants.kSortField)
        settings.synchronize()
        print("Selected sort field: \(selectedItem)")
    }
    override func viewWillAppear(_ animated: Bool) {
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.ksortDirectionAscending), animated: true)
        let sortField = settings.string(forKey: Constants.kSortField)
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0)
    }
    @IBAction func sortDirectionChanged(_ sender: Any){
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.ksortDirectionAscending)
        settings.synchronize()
    }

    
}
