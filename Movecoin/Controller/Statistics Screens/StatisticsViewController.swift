//
//  StatisticsViewController.swift
//  Movecoin
//
//  Created by eww090 on 16/09/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblStatistics: UITableView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
   
    
    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationBarSetUp()
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblStatistics.delegate = self
        tblStatistics.dataSource = self
        tblStatistics.tableFooterView = UIView.init(frame: CGRect.zero)
        
        lblTitle.font = UIFont.semiBold(ofSize: 21)
    }
}

extension StatisticsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.className) as! StatisticsTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}
