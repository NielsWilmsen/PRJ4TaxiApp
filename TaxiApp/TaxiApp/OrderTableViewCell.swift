//
//  OrderTableViewCell.swift
//  TaxiApp
//
//  Created by Niels Wilmsen on 28/05/2020.
//  Copyright © 2020 Niels Wilmsen. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var status: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
