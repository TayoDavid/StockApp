//
//  PanelViewController.swift
//  StockApp
//
//  Created by Omotayo on 10/01/2022.
//

import UIKit

class PanelViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        let grabberView = UIView(frame: CGRect(x: 0, y: 5, width: 50, height: 4))
        grabberView.backgroundColor = .label
        grabberView.center = CGPoint(x: view.center.x, y: 10)
        view.addSubview(grabberView)
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
