//
//  ViewController.swift
//  BucketList
//
//  Created by Shahad Nasser on 12/12/2021.
//

import UIKit

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate {
    
    var items = [Task]()
    
    private var pendingWorkItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "GetTasksQueue")
    
    override func viewDidLoad() {
        fetch()
        super.viewDidLoad()
        print("loaded!")
    }
    
    func fetch(){
        pendingWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem {
             self.getTasks()
        }
        pendingWorkItem = newWorkItem
        queue.sync(execute: newWorkItem)
    }
    
    func getTasks(){
        TaskModel.getAllTasks(completionHandler: {data,response,error in
            guard let myData = data else { return }
            do{
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode([Task].self, from: myData)
                self.items = jsonResult
                print(jsonResult)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        })
    }
    
    func addTask(objective: String){
        TaskModel.addTask(objective: objective) { data, response, error in
            guard let myData = data else { return }
            do{
                if let responseCode = (response as? HTTPURLResponse)?.statusCode{
                    if responseCode == 201 {
                        print("Successfully Added: \(responseCode)")
                        let decoder = JSONDecoder()
                        let jsonResult = try decoder.decode(Task.self, from: myData)
                        self.items.append(Task(id: jsonResult.id, objective: jsonResult.objective, createdAt: jsonResult.createdAt))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        print("i appended")
                    } else {
                        print("Failed to Add: \(responseCode)")
                        return
                    }
                }
            }catch{
                print(error)
            }
        }
    }
    
    func editTask(objective: String, id: Int, index: Int){
        TaskModel.editTask(objective: objective, id: id) { data, response, error in
            if let responseCode = (response as? HTTPURLResponse)?.statusCode{
                if responseCode == 200 {
                    print("Successfully Edited: \(responseCode)")
                    self.items[index].objective = objective
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Failed to Edit: \(responseCode)")
                    return
                }
            }
        }
    }
    
    func deleteTask(id: Int, index: Int){
        TaskModel.deleteTask(id: id) { data, response, error in
            if let responseCode = (response as? HTTPURLResponse)?.statusCode{
                if responseCode == 200 {
                    print("Successfully Deleted: \(responseCode)")
                    self.items.remove(at: index)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Failed to Delete: \(responseCode)")
                    return
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].objective
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.deleteTask(id: self.items[indexPath.row].id, index: indexPath.row)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "AddItemSegue"){
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
        }else if(segue.identifier == "EditItemSegue"){
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTableViewController.item = item
            addItemTableViewController.indexPath = indexPath
        }
    }
    
    func addItem(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            editTask(objective: text, id: items[ip.row].id, index: ip.row)
        }else{
            addTask(objective: text)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}

