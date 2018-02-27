//
//  JSPrivacyWizardContext.swift
//  FBSecurityQuestionnaire
//
//  Created by Cătălin Pomîrleanu on 19/12/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

import JavaScriptCore

class JSPrivacyWizardContext: NSObject {
    
    // MARK: - Properties
    private static var context: JSContext? = {
        
        let context = JSContext()
        
        guard let
            privacyWizardJSPath = Bundle.main.path(forResource: "PrivacyWizardModule", ofType: "js") else {
                print("Unable to read .js files.")
                return nil
        }
        
        do {
            let privacyWizard = try String(contentsOfFile: privacyWizardJSPath, encoding: String.Encoding.utf8)
            _ = context?.evaluateScript(privacyWizard)
        } catch (let error) {
            print("Error while processing script file: \(error)")
        }
        
        return context
    }()
    
    // MARK: - Lifecycle
    private override init() {
        super.init()
    }
    
    // MARK: - Shared Instance
    class var shared : JSPrivacyWizardContext {
        struct Singleton {
            static let instance = JSPrivacyWizardContext()
        }
        return Singleton.instance
    }
    
    // MARK: - Public Methods
    static func getNextQuestionAndSuggestions(selectedOptions: [Int], networks: [String], completionHandler: @convention(block) (NSDictionary) -> Void) {
        guard let context = context else { return }
        context.setObject(unsafeBitCast(completionHandler, to: AnyObject.self), forKeyedSubscript: "callback" as (NSCopying & NSObjectProtocol)!)
        
        let getNextQuestionAndSuggestionsJSFunction = context.objectForKeyedSubscript("getNextQuestionAndSuggestions")
        _ = getNextQuestionAndSuggestionsJSFunction?.call(withArguments: [selectedOptions,
            ACPrivacyWizard.shared.recommendedParameters?.conditionalProbabilitiesMatrix ?? [],
            ACPrivacyWizard.shared.recommendedParameters?.initialProbabilities ?? [],
            ACPrivacyWizard.shared.recommendedParameters?.settingsToOptions ?? [],
            ACPrivacyWizard.shared.recommendedParameters?.optionsToSettings ?? [],
            ACPrivacyWizard.shared.recommendedParameters?.settingsToNetwork ?? [],
            networks])
    }
}
