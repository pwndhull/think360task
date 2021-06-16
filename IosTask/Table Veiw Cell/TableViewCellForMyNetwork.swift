//
//  TableViewCellForMyNetwork.swift
//  IosTask
//
//  Created by Pawan Dhull on 15/06/21.
//

import UIKit

class TableViewCellForMyNetwork: UITableViewCell {

    @IBOutlet weak var CallView: UIView!
    
    @IBOutlet weak var personimage: ImageLoader!
    
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        CallView.layer.cornerRadius = CallView.bounds.width / 2
        personimage.layer.cornerRadius = personimage.bounds.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
