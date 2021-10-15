//
//  DetailTableViewCell.swift
//  Holiday Calendar
//
//  Created by Kate Duncan-Welke on 10/13/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var country: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
