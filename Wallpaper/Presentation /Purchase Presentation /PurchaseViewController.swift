//
//  PurchaseViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 20.02.2022.
//

//import UIKit
//import Purchases
//
//class PurchaseViewController: UIViewController {
//
//    // Outlet properties
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var buyButton: UIButton!
//    @IBOutlet weak var restoreButton: UIButton!
//
//    // MARK: - View life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configure()
//    }
//
//    // MARK: - Button actions
//    @IBAction func backButtonAction(_ sender: Any) {
//        dismiss(animated: true)
//    }
//
//    @IBAction func buyButtonAction(_ sender: Any) {
//        fetchPackages { [weak self] package in
//            self?.purchase(package: package)
//        }
//    }
//
//    @IBAction func resctoreButtonAction(_ sender: Any) {
//        restorePurchase()
//    }
//
//    // Private functions
//    private func configure() {
//        containerView.layer.cornerRadius = 15
//        containerView.clipsToBounds = true
//        containerView.layer.borderWidth = 3.0
//        containerView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
//
//        buyButton.layer.cornerRadius = 10
//        buyButton.clipsToBounds = true
//
//        restoreButton.layer.cornerRadius = 10
//        restoreButton.clipsToBounds = true
//    }
//
//    private func restorePurchase() {
//        Purchases.shared.restoreTransactions { [weak self] info, error in
//
//            guard let info = info, error == nil else {
//                return
//            }
//            print(info)
//            self?.dismiss(animated: true, completion: nil)
//        }
//    }
//
//    private func fetchPackages(completion: @escaping (Purchases.Package) -> Void) {
//        Purchases.shared.offerings { offerings, error in
//            guard let offerings = offerings, error == nil else {
//                return
//            }
//
//            guard let package = offerings.all.first?.value.availablePackages.first else {
//                return
//            }
//
//            completion(package)
//        }
//    }
//
//    private func purchase(package: Purchases.Package) {
//        Purchases.shared.purchasePackage(package) { [weak self] transaction, info, error, userCancelled in
//
//            guard let transaction = transaction,
//                  let info = info,
//                  error == nil, !userCancelled else {
//                      return
//                  }
//
//            self?.dismiss(animated: true, completion: nil)
//        }
//    }
//}
