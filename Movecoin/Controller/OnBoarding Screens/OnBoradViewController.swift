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
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var pageControl : UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    lazy var pageViewController = UIPageViewController()
    var arrayViewControllers    : [UIViewController]   = []
    
    // ----------------------------------------------------
    // MARK: - --------- ViewController Lifecycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp()
        self.initialSetup()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func initialSetup(){
        setUpPageViewController()
        pageControl.numberOfPages = arrayViewControllers.count
    }
    
    func setUpPageViewController() {

        let controller1 = IntroPageVC()
        controller1.image = "intro-1"

        let controller2 = IntroPageVC()
        controller2.image = "intro-2"
        
        let controller3 = IntroPageVC()
        controller3.image = "intro-3"
        
        let controller4 = IntroPageVC()
        controller4.image = "intro-4"

        arrayViewControllers = [controller1,controller2,controller3,controller4]
        
        //page Controller setup
        pageViewController = UIPageViewController(transitionStyle: .scroll
            , navigationOrientation: .horizontal
            , options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
       
        pageViewController.setViewControllers([arrayViewControllers[0]], direction: .forward, animated: true, completion: nil)
        self.addChild(pageViewController)
        viewContainer.addSubview(pageViewController.view)
        self.pageViewController.didMove(toParent: self)
         pageViewController.view.frame = viewContainer.frame
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnSkipTapped(_ sender: Any) {
        AppDelegateShared.GoToLogin()
    }
}

// ----------------------------------------------------
//MARK:- --------- PageviewControler Methods ---------
// ----------------------------------------------------

extension OnBoradViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = arrayViewControllers.firstIndex(of: viewController ) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        let prevIndex = abs((index - 1) % arrayViewControllers.count)
        return arrayViewControllers[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = arrayViewControllers.firstIndex(of: viewController ) else {
            return nil
        }
        
        if index == arrayViewControllers.count - 1 {
            return nil
        }
        
        let nextIndex = abs((index + 1) % arrayViewControllers.count)
        
        return arrayViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let viewController = pageViewController.viewControllers?[0] {
            guard let index = arrayViewControllers.firstIndex(of: viewController ) else {
                return
            }
            print(index)
            pageControl.currentPage = index
            if pageControl.currentPage == arrayViewControllers.count - 1 {
                btnSkip.setTitle("Go >>", for: .normal)
            }else {
                btnSkip.setTitle("Skip >>", for: .normal)
            }
        }
    }
}
