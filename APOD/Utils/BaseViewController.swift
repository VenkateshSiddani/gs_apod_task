//
//  BaseViewController.swift
//  News
//
//  Created by Venkatesh S on 07/03/22.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "News", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class Util {
    static let shared = Util()
    private init(){}

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    func showLoader(view: UIView){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .black
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }

    func hideLoader(){
        DispatchQueue.main.async {
             self.activityIndicator.stopAnimating()
             self.activityIndicator.removeFromSuperview()
         }
    }
}
