//
//  ViewController.swift
//  MyNotes
//
//  Created by macOS on 7/13/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

let appGroup: String = "group.mynotes.app"

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [String]()
    var fileURL: URL!
    var selectedRow: Int = -1
    var newRowText: String = ""
    var query: [String: String]? {
        didSet {
            didOpenWithQuery()
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "My Notes"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
        
        let addItemButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        self.navigationItem.rightBarButtonItem = addItemButton
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL = baseURL.appendingPathComponent("notes.txt")
        
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedRow == -1 {
            didOpenWithQuery()
            return
        }
        
        notes[selectedRow] = newRowText
        
        if newRowText == "" {
            notes.remove(at: selectedRow)
        }
        
        tableView.reloadData()
        saveNotes()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let noteDetailsVC: NoteDetailsViewController = segue.destination as! NoteDetailsViewController
        selectedRow = tableView.indexPathForSelectedRow!.row
        noteDetailsVC.masterVC = self
        noteDetailsVC.setText(with: notes[selectedRow])
    }
    
    func didOpenWithQuery() {
        if !isViewLoaded { return }
        _ = self.navigationController?.popToRootViewController(animated: false)
        guard let query = query else { return }
        
        if query["new"] == "true" {
            addNote()
            return
        }
        if let rowValue = query["note"] {
            if let row = Int(rowValue) {
                let indexPath = IndexPath(row: row, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                performSegue(withIdentifier: "showNoteDetails", sender: nil)
            }
        }
    }
    
    @objc func addNote() {
        if tableView.isEditing { return }
        let name: String = ""
        notes.insert(name, at: 0)
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "showNoteDetails", sender: nil)
    }
    
    func saveNotes() {
        if let userDefaults = UserDefaults(suiteName: appGroup) {
            userDefaults.set(notes, forKey: "notes")
        }
    }
    
    func loadNotes() {
        guard let userDefaults = UserDefaults(suiteName: appGroup) else { return }
        if let loadedNotes = userDefaults.value(forKey: "notes") as? [String] {
            notes = loadedNotes
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveNotes()
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNoteDetails", sender: nil)
    }
    
}
