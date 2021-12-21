//
//  AddItemTableViewController.swift
//  BucketList
//
//  Created by Shahad Nasser on 12/12/2021.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    weak var delegate: AddItemTableViewControllerDelegate?
    var item: Task?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let text = textField.text!
        if validateTextField() {
            delegate?.addItem(by: self, with: text, at: indexPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = item?.objective
    }
    
    func validateTextField()->Bool{
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            let alert = UIAlertController(title: "Field Required", message: "Please enter a task", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                   
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}
