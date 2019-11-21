//
//  MapViewController.swift
//  Movecoin
//
//  Created by eww090 on 12/10/19.
//  Copyright © 2019 eww090. All rights reserved.
//

import UIKit
import MapKit

protocol FlipToHomeDelegate {
    func flipToHome()
}

protocol FriendStatusDelegate {
    func checkFriendStatus(status: FriendsStatus)
}


class MapViewController: UIViewController {
    
    // ----------------------------------------------------
    // MARK: - IBOutlets
    // ----------------------------------------------------
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // ----------------------------------------------------
    // MARK: - Variables
    // ----------------------------------------------------
    
    var delegateFlipToHome : FlipToHomeDelegate!
    var delegateFriendStatus : FriendStatusDelegate!
    var toggleForPopover = false
    
    lazy var annotation1 = MKPointAnnotation()
    lazy var annotation2 = MKPointAnnotation()

    // ----------------------------------------------------
    // MARK: - Life-cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFont()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.setRightBarButton(nil, animated: true)
        navigationBarSetUp(isHidden: false, title: "", backroundColor: .clear, hidesBackButton: true)
        self.setUpNavigationItems()
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    
    
    func setupFont(){
        lblSteps.font = UIFont.semiBold(ofSize: 18)
        lblTitle.font = UIFont.semiBold(ofSize: 17)
    }
    
    func setupView(){
        bottomConstraint.constant = containerView.frame.height
        mapView.delegate = self
        
        // add pin on the Map
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 23.072567, longitude: 72.516277)
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 23.075514, longitude: 72.526177)
        mapView.addAnnotations([annotation1,annotation2])
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func setUpNavigationItems(){
        let flipImage = UIImage(named:"flip-home")!.withRenderingMode(.alwaysOriginal)
        let rightBarButton = UIBarButtonItem(image: flipImage, style: .plain, target: self, action: #selector(btnFlipTapped))
        self.parent?.navigationItem.setRightBarButtonItems([rightBarButton], animated: true)
    }
    
    @objc func btnFlipTapped(){
        self.delegateFlipToHome.flipToHome()
    }
    
    func toggleHandler(isOn : Bool){
        if isOn {
            self.bottomConstraint.constant = 0

            UIView.animate(withDuration: 0.5) {
                 self.view.layoutIfNeeded()
            }
        } else{
            self.bottomConstraint.constant = self.containerView.frame.height

            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let annotation = view.annotation?.coordinate {
            print("Annotation: \(annotation)")
            toggleForPopover = !toggleForPopover
            toggleHandler(isOn: toggleForPopover)
            if annotation.latitude == annotation1.coordinate.latitude && annotation.longitude == annotation1.coordinate.longitude {
                self.delegateFriendStatus.checkFriendStatus(status: FriendsStatus.AlreadyFriend)
            }else{
                self.delegateFriendStatus.checkFriendStatus(status: FriendsStatus.BecomeFriend)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation?.coordinate {
            print("Annotation: \(annotation)")
            toggleForPopover = !toggleForPopover
            toggleHandler(isOn: toggleForPopover)
        }
    }
}
