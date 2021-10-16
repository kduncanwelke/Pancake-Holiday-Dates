//
//  AboutViewController.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/16/21.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: IBActions

    @IBAction func visitAPI(_ sender: UIButton) {
        guard let url = URL(string: "https://www.abstractapi.com") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func visitSite(_ sender: UIButton) {
        guard let url = URL(string: "http://kduncan-welke.com/") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
