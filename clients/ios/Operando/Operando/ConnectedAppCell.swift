//
//  ConnectedAppCell.swift
//  Operando
//
//  Created by RomSoft on 4/12/18.
//  Copyright © 2018 Operando. All rights reserved.
//

import UIKit

enum ConnectedAppCellStyle {
    case permission
    case app
}

class ConnectedAppCell: UITableViewCell {
    
    static let identifier = "ConnectedAppCell"
    
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var permissionDescriptionLabel: UILabel!
    @IBOutlet weak var rightImage: UILabel!

    @IBOutlet weak var mainView: UIView!
    private var style: ConnectedAppCellStyle = .app
    
    @IBOutlet weak var rightArrowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupColorView()
        self.selectionStyle = .none
        self.appImageView.image = #imageLiteral(resourceName: "connected-apps-mob")
    }
    
    func setupWithPermisions(permission:String){
        self.appDescriptionLabel.isHidden = true
        self.appImageView?.isHidden = true
        self.appTitleLabel.isHidden = true
        self.permissionDescriptionLabel.isHidden = false
        self.permissionDescriptionLabel.text = permission
        self.rightArrowImage.isHidden = true
        self.colorView.backgroundColor = ACPoluttionManager.shared.getPermissionColor(permission: permission)
        
        self.setupMainViewBackgroundColor()
    }
    
    func setupLayout(style: ConnectedAppCellStyle) {
        
        self.style = style
        
        switch style {
        case .app:
            permissionDescriptionLabel.isHidden = true
            appDescriptionLabel.isHidden = false
            appTitleLabel.isHidden = false
            appImageView.isHidden = false
        case .permission:
            permissionDescriptionLabel.isHidden = false
            appDescriptionLabel.isHidden = true
            appTitleLabel.isHidden = true
            appImageView.isHidden = true
            rightImage.isHidden = true
        }
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
    
    
    // MARK: - Setups and Utils
    
    func setupWith(app: ConnectedApp){
        self.appTitleLabel.text = app.name
        self.appDescriptionLabel.text = ""
        
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
        
        if app.permissions.count != 0 {
            let score = ACPoluttionManager.shared.calculatePollution(permissions: app.permissions)
            self.appDescriptionLabel.text = "Privacy Pollution: \(score)/10"
            self.colorView.backgroundColor =  ACPoluttionManager.shared.getColorForPermissionsScore(score: score)
        }
        else {
            self.colorView.isHidden = true
        }
    }
    
    private func setupMainViewBackgroundColor() {
        switch ACPrivacyWizard.shared.selectedScope {
        case .facebook:
            mainView.backgroundColor = UIColor.fbPrivacyTopBar
            break
        case .linkedIn:
            mainView.backgroundColor = UIColor.lkPrivacyTopBar
            break
        case .twitter:
            mainView.backgroundColor = UIColor.twPrivacyTopBar
            break
        case .googleLogin:
            mainView.backgroundColor = UIColor.goPrivacyTopBar
            break
        default:
            break
        }
    }
      
}
