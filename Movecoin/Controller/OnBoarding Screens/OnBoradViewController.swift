//
//  OnBoradViewController.swift
//  Movecoins
//
//  Created by eww090 on 20/11/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit

class OnBoradViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
     @IBOutlet weak var viewContainer: UIView!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    lazy var pageViewController = UIPageViewController()
    
    // ----------------------------------------------------
    // MARK: - ViewController Lifecycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    func initialSetup(){
        pageViewController.dataSource = self
        pageViewController.view.frame = viewContainer.frame
        viewContainer.addSubview(pageViewController.view)
    }
}

extension OnBoradViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
