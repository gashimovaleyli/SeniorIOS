//
//  AddBillsVC.swift
//  Nghbrhood
//
//  Created by CTIS Student on 28.02.2021.
//  Copyright © 2021 Nghbrhood. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class AddBillsVC: UIViewController, EKEventViewDelegate, EKEventEditViewDelegate {
    
    let eventStore = EKEventStore()
    
    @IBOutlet weak var datePick: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var bName: UITextField!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTap))
        
        //Check Dark or Light Mode
        if traitCollection.userInterfaceStyle == .light {
            logo.image = UIImage(named: "logo")
        }
        else {
            logo.image = UIImage(named: "logo_white")
        }
    }
    
    @objc func didTap(){
        //Check Bill Name
        let name = String(bName.text!)
        if name.isEmpty {
            let mAlert = UIAlertController(title: "Error", message: "Please, give a name to your bill!", preferredStyle:UIAlertController.Style.alert)
                mAlert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
            self.present(mAlert, animated: true, completion: nil)
        }
        else{
            //Access Calender
            eventStore.requestAccess(to: .event){ [ weak self ]
                success, error in
                if success, error == nil{
                    DispatchQueue.main.async {
                        let name = String(self?.bName.text! ?? "")
                        guard let store = self?.eventStore else { return }
                        let newEvent = EKEvent(eventStore: store)
                        newEvent.title = name
                        newEvent.startDate = self?.datePick.date
                        newEvent.endDate = self?.endDate.date
                        
                        let otherVC = EKEventEditViewController()
                        otherVC.editViewDelegate = self
                        otherVC.eventStore = store
                        otherVC.event = newEvent
                        self?.present(otherVC, animated: true, completion: nil)
                        /*
                        let vc = EKEventViewController()
                        vc.delegate = self
                        vc.event = newEvent
                        let navi = UINavigationController(rootViewController: vc)
                        self?.present(navi, animated: true)*/
                        
                        
                    }
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
        //let mAlert = UIAlertController(title: "Success", message: "Bill added to your calender!", preferredStyle:UIAlertController.Style.alert)
        //mAlert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        //self.present(mAlert, animated: true, completion: nil)
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
