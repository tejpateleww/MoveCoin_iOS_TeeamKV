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
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var delegateFlipToHome : FlipToHomeDelegate!
    var delegateFriendStatus : FriendStatusDelegate!
    var toggleForPopover = false
    
    lazy var nearByUsersArray = [Nearbyuser]()
    
    var nearByuserTimer : Timer!

    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetUp(hidesBackButton: true)
        self.setupFont()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.parent?.navigationItem.leftBarButtonItems?.removeAll()
        self.parent?.navigationItem.setRightBarButton(nil, animated: true)
      
        lblSteps.text = SingletonClass.SharedInstance.todaysStepCount ?? "0"
        self.setUpNavigationItems()
        webserviceForNearByUsers()
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        nearByuserTimer.invalidate()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    func setupFont(){
        lblSteps.font = UIFont.semiBold(ofSize: 18)
        lblTitle.font = UIFont.semiBold(ofSize: 17)
    }
    
    func setupView(){
        bottomConstraint.constant = containerView.frame.height
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(PinMarkerView.self, forAnnotationViewWithReuseIdentifier: "marker")
    }
    
    func setUpNavigationItems(){
        let flipImage = UIImage(named:"flip-home")!.withRenderingMode(.alwaysOriginal)
        let rightBarButton = UIBarButtonItem(image: flipImage, style: .plain, target: self, action: #selector(btnFlipTapped))
        self.parent?.navigationItem.setRightBarButtonItems([rightBarButton], animated: true)
    }
    
    @objc func btnFlipTapped(){
        self.delegateFlipToHome.flipToHome()
    }
    
    func startTimer() {
        if(nearByuserTimer == nil){
            nearByuserTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true, block: { (timer) in
                print(timer)
                if SocketIOManager.shared.socket.status == .connected {
                  self.webserviceForNearByUsers()
                }
            })
        }
    }
    
    func toggleHandler(isOn : Bool, user : Nearbyuser?, annotationView : MKAnnotationView?){
        if isOn {
            for child in self.children{
                if child.isKind(of: PopoverViewController.self) {
                    if let dic = user {
                        (child as! PopoverViewController).annotationView = annotationView
                        (child as! PopoverViewController).webserviceForNearByUserDetails(user: dic)
                    }
                    break
                }
            }
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
    
    func reloadMapView(){
       
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
         
         var artView = [PinMarker]()
        nearByUsersArray.forEach{
             artView.append(PinMarker(data: $0))
         }
         mapView.addAnnotations(artView)
        
//        var annotationsArray = [MKPointAnnotation]()
//        for user in nearByUsersArray {
//            let annotation = MKPointAnnotation()
//            annotation.title = "\(user.fullName ?? "")"
//            let lat = CLLocationDegrees(floatLiteral: Double(user.latitude)!)
//            let lng = CLLocationDegrees(floatLiteral: Double(user.longitude)!)
//            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//            annotationsArray.append(annotation)
//        }
//        mapView.addAnnotations(annotationsArray)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func zoomInLocation(_ location: CLLocation) {
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0012, longitudeDelta: 0.0012)
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: coordinateSpan)
            mapView.centerCoordinate = location.coordinate
            mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // ----------------------------------------------------
    //MARK:- --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func btnNavigateToUser(_ sender: Any) {
        if let myLocation = SingletonClass.SharedInstance.myCurrentLocation {
             zoomInLocation(myLocation)
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- MapView Delegate Methods ---------
// ----------------------------------------------------

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PinMarker else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
       
        if let annotation = view.annotation as? PinMarker {
            print("Annotation: \(annotation)")
            toggleForPopover = !toggleForPopover
            let arr = nearByUsersArray.filter{$0.userID == annotation.id}
            print(arr)
            toggleHandler(isOn: toggleForPopover, user: arr.first, annotationView: view)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation as? PinMarker {
            print("Annotation: \(annotation)")
            toggleForPopover = !toggleForPopover
            toggleHandler(isOn: toggleForPopover, user: nil, annotationView: view)
        }
    }
}

// ----------------------------------------------------
//MARK:- --------- Webservice Methods ---------
// ----------------------------------------------------

extension MapViewController {
    
    func webserviceForNearByUsers(){
    
        guard let id = SingletonClass.SharedInstance.userData?.iD, let myLocation = SingletonClass.SharedInstance.myCurrentLocation else {
            return
        }
//        UtilityClass.showHUD()
        let requestModel = NearByUserModel()
        requestModel.user_id = id
        requestModel.latitude = "\(String(describing: myLocation.coordinate.latitude))"
        requestModel.longitude = "\(String(describing: myLocation.coordinate.longitude))"
        
        FriendsWebserviceSubclass.nearByUsers(nearByUsersModel: requestModel){ (json, status, res) in
           
//            UtilityClass.hideHUD()
            if status {
                let responseModel = NearByUsersResponseModel(fromJson: json)
                self.nearByUsersArray = responseModel.nearbyuser
                self.reloadMapView()
            }
        }
    }
}
