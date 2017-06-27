//
//  UISCDDocumentsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit
import PPCommonTypes

@objc
public protocol SCDRepository {
    func retrieveAllDocuments(with callback: ((_ documents: [SCDDocument]?, _ error: NSError?) -> Void)?)
}

@objc
public enum UISCDDocumentsControllerExitButtonType: Int {
    case TypeArrowLeft
    case TypeArrowUp
    case HamburgerMenu
    case CloseCircleX
    case NoneInvisible
}

@objc
public class CommonUIDisplayModel: NSObject {
    public var titleBarHeight: CGFloat = 64
    public var exitButtonType: UISCDDocumentsControllerExitButtonType = UISCDDocumentsControllerExitButtonType.CloseCircleX
}

struct UISCDDocumentsViewControllerModel {
    let repository: SCDRepository
    let displayModel: CommonUIDisplayModel
}


struct UISCDDocumentsViewControllerCallbacks {
    let whenUserSelectsSCD: ((_ scd: SCDDocument) -> Void)?
    let whenUserSelectsToExit: VoidBlock?
}

let imageNameForType: [UISCDDocumentsControllerExitButtonType: String] = [.CloseCircleX: "close",
                                                                          .HamburgerMenu: "hamburger_Icon",
                                                                          .TypeArrowLeft: "arrow_left",
                                                                          .TypeArrowUp: "arrow_up"];

class UISCDDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var titleBarHeightConstraint: NSLayoutConstraint!
    
    private var model: UISCDDocumentsViewControllerModel?
    private var callbacks: UISCDDocumentsViewControllerCallbacks?
    private var documentsFromRepository: [SCDDocument] = []
    private var cellAtIndexNeedsFullSize: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup(tableView: self.tableView)
    }

    
    func setup(with model: UISCDDocumentsViewControllerModel, callbacks: UISCDDocumentsViewControllerCallbacks){
        self.callbacks = callbacks
        self.model = model
        let _ = self.view
        
        let imageName = imageNameForType[model.displayModel.exitButtonType]
        let image = UIImage(named: imageName ?? "close", in: Bundle.commonUIBundle, compatibleWith: nil)
        self.exitButton.setImage(image, for: .normal)
        if model.displayModel.exitButtonType == .NoneInvisible {
            self.exitButton.isHidden = true
        }
        
        URLSession.shared
        
        weak var weakSelf = self
        self.titleBarHeightConstraint.constant = model.displayModel.titleBarHeight
        model.repository.retrieveAllDocuments(with: { documents, error  in
            if let documents = documents {
                weakSelf?.documentsFromRepository = documents
                weakSelf?.cellAtIndexNeedsFullSize = Array<Bool>(repeating: false, count: self.documentsFromRepository.count)
                weakSelf?.tableView?.reloadData()
            }
        })
    }
    

    private func setup(tableView: UITableView?){
        let nib = UINib(nibName: SCDDocumentCell.identifierNibName, bundle: Bundle.commonUIBundle)
        tableView?.register(nib, forCellReuseIdentifier: SCDDocumentCell.identifierNibName)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.reloadData()
    }
    
    @IBAction func didPressToExit(_ sender: Any) {
        self.callbacks?.whenUserSelectsToExit?()
    }
    
    //MARK: TableView related
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentsFromRepository.count
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let document = self.documentsFromRepository[indexPath.row]
        weak var weakSelf = self
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SCDDocumentCell.identifierNibName, for: indexPath) as! SCDDocumentCell
        
        cell.setup(with: document,
                   inFullSize: self.cellAtIndexNeedsFullSize[indexPath.row],
                   callbacks: SCDDocumentCellCallbacks(whenUserSelectsAdvanced: { 
                    weakSelf?.callbacks?.whenUserSelectsSCD?(document)
                   }, whenRequiresResize: { flag in
                    weakSelf?.cellAtIndexNeedsFullSize[indexPath.row] = flag
                    weakSelf?.tableView?.beginUpdates()
                    weakSelf?.tableView?.endUpdates()
                   }))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellAtIndexNeedsFullSize[indexPath.row] ? UITableViewAutomaticDimension : 90.0;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
