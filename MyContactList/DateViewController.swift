import UIKit

protocol DateControllerDelegate: AnyObject {
    func dataChanged(date: Date)
}

class DateViewController: UIViewController {

    weak var delegate: DateControllerDelegate?

    @IBOutlet weak var dtpDate: UIDatePicker!  // Make sure it's connected in storyboard

    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Birthdate"
    }

    @objc func saveDate() {
        delegate?.dataChanged(date: dtpDate.date)
        navigationController?.popViewController(animated: true)
    }
}
