//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by 桑原望 on 2020/02/16.
//  Copyright © 2020 MySwift. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDoを追加しますか?", message: nil, preferredStyle: .alert)
        //ボタンの追加
        let action: UIAlertAction = UIAlertAction(title: "追加", style: .default) { (void) in
            let textField = alertController.textFields![0] as UITextField
            if let text = textField.text {
               // print("タスクを追加する処理を書きます")
                let toDo = ToDo()
                toDo.text = text
                
                let realm = try! Realm()
                
                try! realm.write {
                    realm.add(toDo)
                }
               // tableViewを更新する
                self.tableView.reloadData()
                //データベースはカウントがないと追加されたか分からない
//                let toDos = realm.objects(ToDo.self)
//                print(toDos.count)
            }
        }
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        //textFieldを追加
        alertController.addTextField { (textField) in
            textField.placeholder = "ToDoの名前を入れてください。"
        }
        alertController.addAction(action)
        alertController.addAction(cancel)
        //alertControllerに表示
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //入力したToDoの数だけセルを表示
        let realm = try! Realm()
        let toDos = realm.objects(ToDo.self)
        
        return toDos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //cellにtextが表示される
        let realm = try! Realm()
        let toDos = realm.objects(ToDo.self)
        let toDo = toDos[indexPath.row]
        cell.textLabel?.text = toDo.text
        // Configure the cell...
        
        return cell
    }
    
    
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        //Delete時の処理
        let realm = try! Realm()
        let toDos = realm.objects(ToDo.self)
        let toDo = toDos[indexPath.row]
        
        try! realm.write {
            realm.delete(toDo)
        }
        // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     }
        // else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     //}
     }
     
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
