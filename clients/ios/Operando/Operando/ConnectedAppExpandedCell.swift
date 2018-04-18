//
//  ConnectedAppExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 4/12/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

class ConnectedAppExpandedCell: UITableViewCell {

    @IBOutlet weak var expandedCellDescription: UILabel!
    @IBOutlet weak var expandedCellTitle: UILabel!
    static let identifier = "ConnectedAppExpandedCell"
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupColorView()
        self.selectionStyle = .none
    }
    
    private func setupColorView(){
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func pressedUnistallButton(_ sender: Any) {
    }
    @IBAction func pressedViewPermissionsButton(_ sender: Any) {
    }
    // MARK: - Setups and Utils
   
    func setupWith(app: ConnectedApp){
        self.expandedCellTitle.text = app.name
        self.expandedCellDescription.text = "Privacy Poluttion: "
    }
    
}
