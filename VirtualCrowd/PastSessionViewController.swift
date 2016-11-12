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
    
    // MARK: Properties
    
    let cloudKitManager = CloudKitManager()
    var detailText: String?
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Past Sessions"
        pastSessionTableView.delegate = self
        pastSessionTableView.dataSource = self
        pastSessionTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
    }

    // MARK: TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionController.sharedController.sortedJoinedSessions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") else { return UITableViewCell() }
        let indexOfArray = indexPath.section + indexPath.row
        let session = SessionController.sharedController.sortedJoinedSessions[indexOfArray]
        
        if session.endDate < Date() {
            detailText = "\(date(date: session.endDate).mediumStyle)"
        } else {
            detailText = "Still Crowded"
        }
        
        cell.textLabel?.text = session.title
        cell.detailTextLabel?.text = detailText
        cell.contentView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    // MARK: Functions
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pastToDetail" {
            let destinationVC = segue.destination as? SessionViewController
            let index = ((pastSessionTableView.indexPathForSelectedRow?.section)! + (pastSessionTableView.indexPathForSelectedRow?.row)!)
            let session = SessionController.sharedController.sortedJoinedSessions[index]
            destinationVC?.session = session
        }
    }
}
