//
//  DetailsViewController.swift
//  Contacts
//
//  Created by FloreaIulian on 12/13/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var contact: Contact?
    var onSave: ((Contact) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        
        configure()
    }
    
    private func configure() {
        if let contact = contact {
            title = "Editeaza contact"
            self.nameTextField.text = contact.firstName
            self.lastNameTextField.text = contact.lastName
            self.phoneTextField.text = contact.phone
            self.emailTextField.text = contact.email
            saveButton.setTitle("Update", for: .normal)
        } else {
            title = "Adauga contact"
            saveButton.setTitle("Salveaza", for: .normal)
        }
    }
    
    @objc private func saveDetails() {
        guard isValidContact() else {
            return
        }
        
        //we could use lagest id + 1 from available but the contacts are filtered by active so that id could still exist
        onSave?(Contact(id: contact?.id,
                        name: "\(nameTextField.text ?? "") \(lastNameTextField.text ?? "")",
                        email: emailTextField.text,
                        phone: phoneTextField.text,
                        gender: nil,
                        status: .active))
        self.navigationController?.popViewController(animated: true)
    }
    
    private func isValidContact() -> Bool {
        guard let text = nameTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        
        guard let text = lastNameTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        
        if let text = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty, text.count != 12 {
            return false
        }
        
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
