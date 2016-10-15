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
    
    @IBOutlet weak var pastCrowdsTitleTextLabel: UILabel!
    @IBOutlet weak var pastSessionTableView: UITableView!
    
    // MARK: View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        pastSessionTableView.tableFooterView = UIView()
        pastSessionTableView.delegate = self
        pastSessionTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SessionController.sharedController.inactiveSessions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pastSessionCell") else { return UITableViewCell() }
        let sessionsArray = SessionController.sharedController.inactiveSessions
        let indexOfArray = indexPath.section + indexPath.row
        let session = sessionsArray[indexOfArray]
        
        cell.textLabel?.text = session.title
        cell.detailTextLabel?.text = String(describing: date(date: session.endDate).mediumStyle)
        
        cell.contentView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupBackButton() {
        let back = UIButton()
        back.layer.frame = CGRect(x: 15, y: 35, width: 40, height: 20)
        back.clipsToBounds = true
        back.setTitle("Back", for: .normal)
        back.setTitleColor(UIColor.blue, for: .normal)
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(back)
        view.bringSubview(toFront: back)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pastToDetail" {
            let destinationVC = segue.destination as? SessionViewController
            let sessionArray = SessionController.sharedController.inactiveSessions
            let index = pastSessionTableView.indexPathForSelectedRow
            let session = sessionArray[ (index?.section)! + (index?.row)!]
            destinationVC?.session = session
        }
    }
}
