//
//  TotalStepsViewController.swift
//  Movecoin
//
//  Created by eww090 on 07/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class TotalStepsViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var tblTotalSteps: UITableView!
    
    @IBOutlet weak var lblTotalSteps: UILabel!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationBarSetUp(isHidden: false, title: "Total Steps", hidesBackButton: false)
    }
  
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func setUpView(){
        // Tableview setup
        tblTotalSteps.delegate = self
        tblTotalSteps.dataSource = self
        tblTotalSteps.tableFooterView = UIView.init(frame: CGRect.zero)
        lblTotalSteps.font = UIFont.semiBold(ofSize: 24)
    }
}

extension TotalStepsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TotalStepsTableViewCell.className) as! TotalStepsTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}

