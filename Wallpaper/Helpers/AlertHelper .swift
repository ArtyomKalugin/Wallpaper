//
//  AlertHelper .swift
//  Wallpaper
//
//  Created by Artem Kalugin on 26.01.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Public functions 
    public func showAlert(title: String?, body: String?, button: String?, actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        for action in (actions ?? []) {
            alert.addAction(action)
        }
        
        if let button = button {
            let lastButton = UIAlertAction(title: button, style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(lastButton)
        }
        
        if let _ = alert.popoverPresentationController {
            alert.popoverPresentationController!.sourceView = self.view
            alert.popoverPresentationController!.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            alert.popoverPresentationController!.permittedArrowDirections = [.down]
        }
        
        present(alert, animated: true, completion: nil)
    }
}
