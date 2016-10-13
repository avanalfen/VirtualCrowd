//
//  PastSessionViewController.swift
//  VirtualCrowd
//
//  Created by Austin Van Alfen on 10/12/16.
//  Copyright © 2016 VanRoyal. All rights reserved.
//

import UIKit

class PastSessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    
    @IBOutlet weak var pastSessionTableView: UITableView!
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Past Sessions"
        pastSessionTableView.delegate = self
        pastSessionTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: TableView
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionController.sharedController.sessions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") else { return UITableViewCell() }
        let sessionsArray = SessionController.sharedController.sessions.filter({ $0.isActive == false })
        let indexOfArray = indexPath.section + indexPath.row
        let session = sessionsArray[indexOfArray]
        
        cell.textLabel?.text = session.title
        cell.detailTextLabel?.text = String(describing: date(date: session.date).mediumStyle)
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pastToDetail" {
            let destinationVC = segue.destination as? SessionViewController
            let sessionArray = SessionController.sharedController.sessions.filter({ $0.isActive == false })
            let index = pastSessionTableView.indexPathForSelectedRow
            let session = sessionArray[ (index?.section)! + (index?.row)!]
            destinationVC?.session = session
        }
    }
}
