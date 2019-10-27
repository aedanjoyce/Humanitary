//
//  LocationSearchController.swift
//  Humanitary
//
//  Created by Aedan Joyce on 2/3/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
import GooglePlaces
class LocationSearchController: UIViewController, UISearchControllerDelegate {
    var searchController: UISearchController?
    var delegate: SearchDelegate?
    var resultsViewController: GMSAutocompleteResultsViewController?
   // let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        configureSearchBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismiss))
    }
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    func configureSearchBar() {
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController?.searchBar.placeholder = "Search for places"
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.sizeToFit()
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.backgroundColor = UIColor.white
        definesPresentationContext = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(0.01) { self.searchController?.searchBar.becomeFirstResponder() }
        }
        func delay(_ delay: Double, closure: @escaping ()->()) {
            let when = DispatchTime.now() + delay
            DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
        }
}
// Handle the user's selection.
extension LocationSearchController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true) {
            self.delegate?.pushToStoryPlaceController(place: place)
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
