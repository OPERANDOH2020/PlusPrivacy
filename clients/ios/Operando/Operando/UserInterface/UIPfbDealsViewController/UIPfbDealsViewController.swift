//
//  UIPfbDealsViewController.swift
//  Operando
//
//  Created by Costin Andronache on 10/18/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

class UIPfbDealsViewController: UIViewController {

    @IBOutlet weak var pfbDealsListView: UIPfbDealsListView!
    private var dealsRepository: PrivacyForBenefitsRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupWith(dealsRepository: PrivacyForBenefitsRepository?){
        self.dealsRepository = dealsRepository
        self.loadCurrentDeals()
    }
    
    private func loadCurrentDeals(){
        ProgressHUD.show(kConnecting, autoDismissAfter: 5.0)
        self.dealsRepository?.getCurrentPfbDealsWith(completion: { deals, error in
            ProgressHUD.dismiss()
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            self.pfbDealsListView.setupWith(deals: deals, andCalllbacks: self.callbacksForDealsListView())
        })
    }
    
    
    
    
    private func callbacksForDealsListView() -> UIPfbDealsListViewCallbacks?{
        weak var welf = self
        return UIPfbDealsListViewCallbacks(whenSelectingCellWithDeal: { cell, deal in
            UIPfbDetailsAlertViewController.displayWith(deal: deal, andCallbacks: welf?.callbacksForDealDetailsViewPresentedFrom(dealCell: cell, for: deal))
            }, cellCallbacks: self.callbacksForDealCells())
    }
    
    private func callbacksForDealCells() -> UIPfbDisplayingViewCallbacks? {
        weak var welf = self
        
        return UIPfbDisplayingViewCallbacks(whenUserTappedLink: { link in
            welf?.tryOpen(url: link)
            }, whenUserChangedSubscribedStatusFor: { deal, view  in
                if !deal.subscribed {
                    welf?.tryActivate(deal: deal, fromCell: view, whenDone: nil)
                } else {
                    welf?.tryDeactivate(deal: deal, fromCell: view, whenDone: nil)
                }
        })
    }
    
    
    
    private func tryOpen(url: String){
        guard let actualURL = URL(string: url), UIApplication.shared.canOpenURL(actualURL) else {
            return
        }
        UIApplication.shared.openURL(actualURL)
    }
    
    
    private func tryActivate(deal: PfbDeal, fromCell cell: UIPfbDisplayingView?, whenDone: VoidBlock?){
        ProgressHUD.show(kConnecting, autoDismissAfter: 5.0)
        self.dealsRepository?.subscribeFor(serviceId: deal.serviceId, withCompletion: { dealUpdate, error in
            defer {
                whenDone?()
                ProgressHUD.dismiss()
            }
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }
            
            
            deal.updateWith(update: dealUpdate)
            cell?.refreshWithOwnModel()
        })
    }
    
    private func tryDeactivate(deal: PfbDeal, fromCell cell: UIPfbDisplayingView?, whenDone: VoidBlock?){
        ProgressHUD.show(kConnecting, autoDismissAfter: 5.0)
        self.dealsRepository?.unSubscribeFrom(serviceId: deal.serviceId, withCompletion: { dealUpdate, error  in
            defer{
                whenDone?()
                ProgressHUD.dismiss()
            }
            if let error = error {
                OPErrorContainer.displayError(error: error)
                return
            }

            deal.updateWith(update: dealUpdate)
            cell?.refreshWithOwnModel()
        })
    }
    
    
    
    private func callbacksForDealDetailsViewPresentedFrom(dealCell: UIPfbDisplayingView?, for deal: PfbDeal) -> UIPfbDisplayingViewCallbacks?{
        weak var weakSelf = self
        return UIPfbDisplayingViewCallbacks(whenUserTappedLink: { link in
            weakSelf?.tryOpen(url: link)
            }, whenUserChangedSubscribedStatusFor: { sameDeal, differentView in
                
                let whenDone = {
                    differentView.refreshWithOwnModel()
                }
                if !deal.subscribed {
                    weakSelf?.tryActivate(deal: deal, fromCell: dealCell, whenDone: whenDone)
                } else {
                    weakSelf?.tryDeactivate(deal: deal, fromCell: dealCell, whenDone: whenDone)
                }
        })
        
    }
    
}
