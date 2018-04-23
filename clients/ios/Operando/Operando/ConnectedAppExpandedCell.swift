//
//  ConnectedAppExpandedCell.swift
//  Operando
//
//  Created by RomSoft on 4/12/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

protocol ConnectedAppExpandedCellDelegate {
    func unistallApp(appID: String)
}

class ConnectedAppExpandedCell: UITableViewCell {

    @IBOutlet weak var expandedCellDescription: UILabel!
    @IBOutlet weak var expandedCellTitle: UILabel!
    static let identifier = "ConnectedAppExpandedCell"
    private var permissions: [String]? = []
    private var callbacks: UIConnectedTableViewControllerCallbacks?
    private var appId: String?
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var viewPermissionsView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    
    var delegate:ConnectedAppExpandedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupColorView()
        self.selectionStyle = .none
        self.appImageView.image = #imageLiteral(resourceName: "connected-apps-mob")
    }
    
    private func setupColorView(){
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.layer.borderWidth = 1
        colorView.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Actions
    
    @IBAction func pressedUnistallButton(_ sender: Any) {
        
        if let appId = self.appId {
            
            delegate?.unistallApp(appID: appId)
        }
    }
    
    @IBAction func pressedViewPermissionsButton(_ sender: Any) {
        if let permissions = self.permissions {
            callbacks?.showPermissions?(permissions)
        }
    }
    // MARK: - Setups and Utils
   
    func setupWith(app: ConnectedApp,callbacks: UIConnectedTableViewControllerCallbacks){
        self.expandedCellTitle.text = app.name
        self.expandedCellDescription.text = "Privacy Polselfion: "
        self.permissions = app.permissions
        self.appId = app.appId
        self.callbacks = callbacks
        
        if self.permissions == nil ||
            self.permissions?.count == 0{
            viewPermissionsView.isHidden = true
        }
        else {
            viewPermissionsView.isHidden = false
        }
        
        if let appIconURL = app.iconURL
        {
            var modifiedURL1 = appIconURL.replace(target: "\\", withString: "%");
            modifiedURL1 = modifiedURL1.replace(target: " ", withString: "");
            modifiedURL1 = modifiedURL1.decodeUrl()
            if modifiedURL1.contains(find: ".svg") == true {
            }
            else if let url = URL(string: modifiedURL1){
                
                self.appImageView?.setImageWith(url)
            }
        }
    }
    
}
