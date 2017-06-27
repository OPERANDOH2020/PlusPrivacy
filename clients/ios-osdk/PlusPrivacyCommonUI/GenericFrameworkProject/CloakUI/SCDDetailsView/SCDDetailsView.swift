//
//  SCDDetailsView.swift
//  Operando
//
//  Created by Costin Andronache on 1/9/17.
//  Copyright © 2017 Operando. All rights reserved.
//

import UIKit
import PPCommonTypes

fileprivate protocol SectionSource: class, UITableViewDataSource {
    var sectionTitle: String {get}
}

fileprivate class UrlListSectionSource: NSObject, SectionSource {
    internal var sectionTitle: String {
        return "Urls accessed by this app";
    }

    
    private let scd: SCDDocument
    
    init(scd: SCDDocument) {
        self.scd = scd
        super.init()
    }
    
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scd.accessedHosts.count
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SCDUrlCell.identifierNibName) as! SCDUrlCell
        cell.setupWith(url: self.scd.accessedHosts[indexPath.row])
        return cell
    }
}

fileprivate class SensorListSectionSource: NSObject, SectionSource {
    internal var sectionTitle: String {
        return "Sensors accessed by this app";
    }
    
    private let scd: SCDDocument
    
    init(scd: SCDDocument) {
        self.scd = scd
        super.init()
    }
    
    fileprivate func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scd.accessedInputs.count
    }
    
    fileprivate func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SCDSensorCell.identifierNibName) as! SCDSensorCell
        cell.setupWith(sensor: self.scd.accessedInputs[indexPath.row]);
        return cell
    }
}

class SCDDetailsView: PPNibDesignableView, UITableViewDelegate, UITableViewDataSource {
   
    private var sectionSources: [SectionSource] = []
    private var sectionRowsAreVisibleAt: [Bool] = [false, false]
    private var headerModelsPerSection: [Int: SCDSectionHeaderModel] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    private var scd: SCDDocument?
    
    
    override func commonInit() {
        super.commonInit()
        self.setup(tableView: self.tableView)
    }
    
    func setupWith(scd: SCDDocument){
        self.scd = scd
        
        if scd.accessedHosts.count > 0 {
            self.sectionSources.append(UrlListSectionSource(scd: scd))
        }
        
        if scd.accessedInputs.count > 0 {
            self.sectionSources.append(SensorListSectionSource(scd: scd))
        }
        
        for i in 0..<self.sectionSources.count {
            let sectionSource = self.sectionSources[i];
            self.headerModelsPerSection[i] = SCDSectionHeaderModel(name: sectionSource.sectionTitle, expanded: false, enabled: true)
        }
        
        self.tableView.reloadData()
    }
    
    
    
    private func setup(tableView: UITableView?){
        let bundle: Bundle? = Bundle.commonUIBundle
        let urlCellNib = UINib(nibName: SCDUrlCell.identifierNibName, bundle: bundle)
        let sensorCellNib = UINib(nibName: SCDSensorCell.identifierNibName, bundle: bundle)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.register(urlCellNib, forCellReuseIdentifier: SCDUrlCell.identifierNibName)
        tableView?.register(sensorCellNib, forCellReuseIdentifier: SCDSensorCell.identifierNibName)
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionSources.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = self.headerModelsPerSection[section] else {
            return nil
        }
        return self.createSectionHeaderFor(section: section, withModel: model)
    }
    
    
    private func createSectionHeaderFor(section: Int, withModel model: SCDSectionHeaderModel) -> SCDSectionHeader {
        let header =  SCDSectionHeader(frame: .zero)
        
        weak var weakSelf = self
        
        let buildIndexPathsForSection: (_ section: Int) -> [IndexPath] = { sectionIndex in
            let numOfRows = weakSelf!.sectionSources[sectionIndex].tableView(weakSelf!.tableView, numberOfRowsInSection: 0)
            var indexPaths: [IndexPath] = []
            for i in 0..<numOfRows {
                indexPaths.append(IndexPath(row: i, section: section))
            }
            
            return indexPaths
        }
        
        
        header.setupWith(model: model, callbacks: SCDSectionHeaderCallbacks(
            callToExpand: { callbackToConfirm in
                weakSelf?.sectionRowsAreVisibleAt[section] = true
                weakSelf?.tableView.insertRows(at: buildIndexPathsForSection(section), with: .automatic)
                callbackToConfirm(true)
                
        }, callToContract: { callbackToConfirm in
            weakSelf?.sectionRowsAreVisibleAt[section] = false
            weakSelf?.tableView.deleteRows(at: buildIndexPathsForSection(section), with: .automatic)
            callbackToConfirm(true)
        }))
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < self.sectionSources.count && self.sectionRowsAreVisibleAt[section] else {
            return 0
        }
        return self.sectionSources[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < self.sectionSources.count else {
            return UITableViewCell()
        }
        
        return self.sectionSources[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}
