//
//  TodayViewController.swift
//  MyNotes Widget
//
//  Created by macOS on 7/14/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import NotificationCenter

let appGroup: String = "group.mynotes.app"

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var tableView: UITableView!
    
    var notes = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else {
            self.preferredContentSize = CGSize(width: 0, height: 240)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        guard let userDefaults = UserDefaults(suiteName: appGroup) else { return }
        guard let loadedNotes = userDefaults.array(forKey: "notes") as? [String] else {
            completionHandler(.failed)
            return
        }
        let isSameNotes: Bool = notes.elementsEqual(loadedNotes)
        print(isSameNotes)
        if !isSameNotes {
            notes = loadedNotes
            tableView.reloadData()
            completionHandler(.newData)
            return
        }
        
        completionHandler(.noData)
    }
    
    @IBAction func createNewNote(_ sender: Any) {
        openApp("?new=true")
    }
    
    @IBAction func viewAllNotes(_ sender: Any) {
        openApp("")
    }
    
    func openApp(_ params: String) {
        let urlString = "mynotes://openApp\(params)"
        let url = URL(string: urlString)!
        extensionContext?.open(url, completionHandler: nil)
    }
}

extension TodayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }
}

extension TodayViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let params = "?new=false&note=\(indexPath.row)"
        openApp(params)
    }
}
