//
//  DecisionTableViewCell.swift
//  Decidee
//
//  Created by Naufaldi Athallah Rifqi on 06/05/21.
//

import UIKit

class DecisionTableViewCell: UITableViewCell {

    @IBOutlet weak var argumentLabel: UILabel!
    @IBOutlet weak var decisionTitleLabel: UILabel!
    @IBOutlet weak var argumentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
