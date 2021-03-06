//
//  PurchaseViewController.swift
//  Wallpaper
//
//  Created by Artem Kalugin on 20.02.2022.
//

import UIKit
import Purchases

class PurchaseViewController: UIViewController {

    // Outlet properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var annualContainerView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var backgroundView: UITextView!
    
    //Private properties
    private var condition = 0
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    // Objc functions
    @objc func handleLeftTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        condition = 0
        annualContainerView.layer.borderColor = #colorLiteral(red: 0.2816390693, green: 0.3066759408, blue: 0.3362169862, alpha: 0)
        containerView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    @objc func handleRightTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        condition = 1
        containerView.layer.borderColor = #colorLiteral(red: 0.2816390693, green: 0.3066759408, blue: 0.3362169862, alpha: 0)
        annualContainerView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }

    // MARK: - Button actions
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func buyButtonAction(_ sender: Any) {
        fetchPackages { [weak self] package in
            self?.purchase(package: package)
        }
    }

    // Private functions
    private func configure() {
        backgroundView.backgroundColor = #colorLiteral(red: 0.05580576509, green: 0.05732079595, blue: 0.07379911095, alpha: 0.7542166805)
        
        let leftRecognizer = UITapGestureRecognizer()
        leftRecognizer.addTarget(self, action: #selector(handleLeftTapGesture(_:)))
        containerView.addGestureRecognizer(leftRecognizer)
        
        let rightRecognizer = UITapGestureRecognizer()
        rightRecognizer.addTarget(self, action: #selector(handleRightTapGesture(_:)))
        annualContainerView.addGestureRecognizer(rightRecognizer)
        
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        containerView.layer.borderWidth = 3.0
        containerView.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        annualContainerView.layer.cornerRadius = 15
        annualContainerView.clipsToBounds = true
        annualContainerView.layer.borderWidth = 3.0
        annualContainerView.layer.borderColor = #colorLiteral(red: 0.2816390693, green: 0.3066759408, blue: 0.3362169862, alpha: 0)
        
        buyButton.layer.cornerRadius = 10
        buyButton.clipsToBounds = true
        
        let attributedString = NSMutableAttributedString(string: "Privacy policy")
        let url = URL(string: "https://docs.google.com/document/d/1jpApSDJ9pONmiOO2zAQKF5mwo5hZpG6U-80sQatP_T4/edit?usp=sharing")!
        attributedString.setAttributes([.link: url, .font: UIFont(name: "Helvetica Neue", size: 18.0)], range: NSMakeRange(0, attributedString.length))
        privacyTextView.attributedText = attributedString
        privacyTextView.isUserInteractionEnabled = true
        privacyTextView.isEditable = false
        privacyTextView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        privacyTextView.textAlignment = .center
        privacyTextView.backgroundColor = #colorLiteral(red: 0.05580576509, green: 0.05732079595, blue: 0.07379911095, alpha: 0)
    }

    private func fetchPackages(completion: @escaping (Purchases.Package) -> Void) {
        Purchases.shared.offerings { [weak self] offerings, error in
            guard let offerings = offerings, error == nil else {
                return
            }
            
            if self?.condition == 0 {
                guard let package = offerings.all.first?.value.availablePackages.first else {
                    return
                }
                
                completion(package)
                
            } else {
                guard let package = offerings.all.first?.value.availablePackages[1] else {
                    return
                }
                
                completion(package)
            }
        }
    }

    private func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { [weak self] transaction, info, error, userCancelled in

            guard let transaction = transaction,
                  let info = info,
                  error == nil, !userCancelled else {
                      return
                  }

            self?.dismiss(animated: true, completion: nil)
        }
    }
}
