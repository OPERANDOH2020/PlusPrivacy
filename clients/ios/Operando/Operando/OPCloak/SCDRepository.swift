//
//  SCDRepository.swift
//  Operando
//
//  Created by Costin Andronache on 12/20/16.
//  Copyright © 2016 Operando. All rights reserved.
//

//import Foundation
//import PlusPrivacyCommonTypes
//import PlusPrivacyCommonUI
//
//typealias SCDDocumentCallback = (_ scd: SCDDocument?, _ error: NSError?) -> Void
//typealias ErrorCallback = (_ error: NSError?) -> Void
//
//protocol SCDRepository {
//    func registerSCDJson(_ json: [String: Any], withCompletion completion: ErrorCallback?)
//    func retrieveSCDDocument(basedOnBundleId id: String, withCompletion completion: SCDDocumentCallback?)
//}
//
//
//
//class PlistSCDRepository: SCDRepository, PlusPrivacyCommonUI.SCDRepository {
//    
//    private let plistFilePath: String
//    private var scdDocuments: [SCDDocument]
//    private var scdJSONS: [[String: Any]]
//    
//    init(plistFilePath: String) {
//        self.plistFilePath = plistFilePath
//        self.scdDocuments = []
//        self.scdJSONS = []
//        self.loadPlistObjects()
//    }
//    
//    private func loadPlistObjects() {
//        self.debugRegisterSIMAP_PW()
//        
//        guard let plistArray = NSArray(contentsOfFile: self.plistFilePath),
//            let plistDictsArray = plistArray as? [[String : Any]] else {
//                return
//        }
//
//        CommonTypeBuilder.sharedInstance.buildFromJSON(array: plistDictsArray) { documents, error  in
//            if let documents = documents {
//                self.scdDocuments.append(contentsOf: documents)
//                self.scdJSONS.append(contentsOf: plistDictsArray)
//            }
//        }
//    }
//    
//    internal func retrieveAllDocuments(with completion: (([SCDDocument]?, NSError?) -> Void)?) {
//        completion?(self.scdDocuments, nil)
//    }
//
//    internal func retrieveSCDDocument(basedOnBundleId id: String, withCompletion completion: SCDDocumentCallback?) {
//        let item = self.scdDocuments.first { doc -> Bool in
//            return doc.bundleId == id
//        }
//        
//        completion?(item, nil)
//    }
//
//    internal func registerSCDJson(_ json: [String : Any], withCompletion completion: ErrorCallback?) {
//        CommonTypeBuilder.sharedInstance.buildSCDDocument(with: json) { document, error  in
//            
//            guard let scdDocument = document else {
//                completion?(error)
//                return
//            }
//            self.scdJSONS.append(json)
//            self.scdDocuments.append(scdDocument)
//            self.synchronize()
//            completion?(nil)
//        }
//    }
//
//    
//    private func debugRegisterSIMAP_PW() {
//        guard self.scdDocuments.first(where: {
//            return $0.bundleId == "eu.romsoft.SIMAP" || $0.bundleId == "eu.romsoft.PrivacyWizard"
//        }) == nil else {
//            return
//        }
//        
//        let simapDict: [String: Any] = ["title":"SIMAP",
//                                        "bundleId": "eu.romsoft.SIMAP",
//                                        "accessedHosts": ["simap.rms.ro"],
//                                        "accessedInputs": []]
//        
//        let privacyWizardDict: [String: Any] = ["title": "PrivacyWizard",
//                                                "bundleId": "eu.romsoft.PrivacyWizard",
//                                                "accessedHosts": ["plusprivacy.com"],
//                                                "accessedInputs": []]
//        
//        self.registerSCDJson(simapDict, withCompletion: nil)
//        self.registerSCDJson(privacyWizardDict, withCompletion: nil)
//    }
//    
//    private func synchronize() {
//        let array = NSMutableArray()
//        for jsonDict in self.scdJSONS {
//            array.add(jsonDict as NSDictionary)
//        }
//        guard array.write(toFile: self.plistFilePath, atomically: true) else {
//            print("could not wrtie to file")
//            return
//        }
//        
//    }
//}
