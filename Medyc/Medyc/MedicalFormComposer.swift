//
//  MedicalFormComposer.swift
//  Medyc
//
//  Created by Mazen Kourouche on 5/3/17.
//  Copyright © 2017 Mazen Kourouche. All rights reserved.
//

import UIKit

class MedicalFormComposer: NSObject {

    
    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "medicalHistoryMedyc", ofType: "html")
    var pdfFilename: String!
    
    var defaultsKeys = ["Personal Details":["userFirstName", "userLastName", "userAddress", "userPhoneH", "userPhoneM", "userGender", "userDOB", "userWight", "userHeight"], "Emergency Contact":["emergenctFirstName", "emergenctLastName", "emergencyPhoneH", "emergencyPhoneM", "emergencyRelationship"], "Health Care":["healthDocName", "healthDocPhone", "healthCareNo", "healthFundName", "healthFundNo"], "Medical Details":["userBloodType", "userAcceptsTrans", "userAllergies", "userConditions", "userMedications"]]
    
    var sectionTitles = ["Personal Details", "Emergency Contact", "Health Care", "Medical Details"]
    
    override init() {
        super.init()
    }
    
    func renderForm() -> String! {
        
        do {
            
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            for title in sectionTitles {
                for key in defaultsKeys[title]! {
                    if let retrievedValue = UserDefaults.standard.object(forKey: key) as? String {
                        
                        HTMLContent = HTMLContent.replacingOccurrences(of: "#\(key)#", with: retrievedValue)
                    }
                }
            }
            
            return HTMLContent
            
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = MedicalFormPrintRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
        
        pdfFilename = "MedicalFormMedyc.pdf"
        docURL = docURL?.appendingPathComponent(pdfFilename)
        
        pdfData?.write(to: docURL!, atomically: true)
        //pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
    }
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        printPageRenderer.prepare(forDrawingPages: NSMakeRange(0, printPageRenderer.numberOfPages))
        
        let bounds = UIGraphicsGetPDFContextBounds()
        
        for i in 0...(printPageRenderer.numberOfPages - 1) {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        return data
    }
    
    func getFileName() -> String {
        return self.pdfFilename
    }
}
