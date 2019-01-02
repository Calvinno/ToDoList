//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Calvin Cantin on 2018-12-29.
//  Copyright © 2018 Calvin Cantin. All rights reserved.
//

import UIKit
import MessageUI

class ToDoViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isPickerHidden = true
    var todo: ToDo?
    
    static let dueDateFormater: DateFormatter =
    {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .short
        return formater
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo
        {
            navigationItem.title = "To-Do"
            isCompleteButton.isSelected = todo.isComplete
            titleTextField.text = todo.title
            dueDateLabel.text = ToDoViewController.dueDateFormater.string(from: todo.dueDate)
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        }
        else
        {
        dueDatePickerView.date = Date().addingTimeInterval(60*60*24)
        }
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else
        {
            print("Cannot send a email")
            return
        }
        guard MFMessageComposeViewController.canSendText() else {
            print("Cannot send text")
            return
        }
        let title =  titleTextField.text ?? ""
        guard !title.isEmpty else {
            print("You must add a title")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.delegate = self
        mailComposer.setSubject(title)
        mailComposer.setMessageBody("Due date: \(ToDoViewController.dueDateFormater.string(from: dueDatePickerView.date))\n Notes: \(notesTextView.text ?? "")", isHTML: false)
        present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSaveButtonState()
    {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date)
    {
        dueDateLabel.text = ToDoViewController.dueDateFormater.string(from: date)
    }
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let normalHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch indexPath {
        case [1,0]:
            return isPickerHidden ? normalHeight : largeCellHeight
        case [2,0]:
            return largeCellHeight
        default:
            return normalHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath
        {
        case [1,0]:
            isPickerHidden = !isPickerHidden
            dueDateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
    
}
