//
//  NoteDetailsViewController.swift
//  MyNotes
//
//  Created by macOS on 7/14/19.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {
    
    var text: String = ""
    var masterVC: ViewController!
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textView.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterVC.newRowText = textView.text
        textView.resignFirstResponder()
    }
    
    func setText(with text: String) {
        self.text = text
        if isViewLoaded {
            textView.text = text
        }
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
