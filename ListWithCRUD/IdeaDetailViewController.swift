//
//  IdeaDetailViewController.swift
//  ListWithCRUD
//
//  Created by mobapp12 on 21/01/2020.
//  Copyright © 2020 H3AR7B3A7. All rights reserved.
//

import UIKit

class IdeaDetailViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTV: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    var ideaToUpdate:Idea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let forcedIdea = ideaToUpdate {
            titleTF.text = forcedIdea.title
            contentTV.text = forcedIdea.content
        }
        
        titleChanged()
    }
    
    @IBAction func titleChanged() {
        if titleTF.text!.count >= 3 {
            saveBtn.isEnabled = true
        }else{
            saveBtn.isEnabled = false
        }
    }
    
    @IBAction func saveIdea(_ sender: Any) {
        if ideaToUpdate != nil {
            Repo.sharedInstance.updateIdea(objectId: ideaToUpdate!.objectID, title: titleTF.text!, content: contentTV!.text)
        }else{
            Repo.sharedInstance.saveIdea(title: titleTF.text!, content: contentTV.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        titleTF.resignFirstResponder()
        contentTV.resignFirstResponder()
    }
    
}
