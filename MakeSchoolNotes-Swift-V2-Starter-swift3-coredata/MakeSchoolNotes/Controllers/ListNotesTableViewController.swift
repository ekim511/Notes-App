//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

//creates table view controller  of type UITableViewController (delegation)
class ListNotesTableViewController: UITableViewController {
    
    //creates array of Notes, 
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        // 1 To make the newest note the first displayed
        let row = notes.count - indexPath.row - 1
        
        // 2 append note object to array
        let note = notes[row]
        
        // 3 make the note title label in table view equal to title of note
        cell.noteTitleLabel.text = note.title
        
        // 4 same with modification time
        cell.noteModificationTimeLabel.text = note.modificationTime?.convertToString()
        
        cell.notePreview.text = note.content
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
    }
    
    //prepare before notes page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayNote" {
                print("Table view cell tapped")
                
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let note = notes[notes.count - indexPath.row - 1]
                // 3
                let displayNoteViewController = segue.destination as! DisplayNoteViewController
                // 4
                displayNoteViewController.note = note
                
                displayNoteViewController.navigationItem.title = note.title
                
            } else if identifier == "addNote" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue){
        self.notes = CoreDataHelper.retrieveNotes()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //1
            CoreDataHelper.delete(note: notes[notes.count - indexPath.row - 1])
            //2
            notes = CoreDataHelper.retrieveNotes()
        }
    }
}
