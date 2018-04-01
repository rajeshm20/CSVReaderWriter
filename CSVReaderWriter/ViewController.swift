//
//  ViewController.swift
//  CSVReaderWriter
//
//  Created by Rajesh Mani on 01/04/18.
//  Copyright © 2018 Rajesh Mani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var textView: UITextView!
    
    var data: [[String: String]] = []
    var columnTitles: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readDataFromFile(file: String)-> String{
     
        guard let filePath = Bundle.main.path(forResource: file, ofType: "csv") else{
            return "No file found"
        }
        
        do {
            
            let contents = try String.init(contentsOfFile: filePath)
            return contents
            
        } catch {
            print("file read error for file \(filePath)")
            return "Error no data"
        }
    }
    
    
    func writeDataToFile(file: String) -> Bool {
        //Check our data exists
        guard  let data = textView.text else {
            return false
        }
        //get the file path for the file from the bundle
        //if it doesn't exists make it in the bundle
        var fileName = file + ".txt"
            
        if let filePath = Bundle.main.path(forResource: file, ofType: "csv"){
            fileName = filePath
            print(fileName)
        } else {
            
            fileName = Bundle.main.bundlePath + fileName
        }
        
        //write the file, return true if works, false otherwise
        
        do {
            try data.write(toFile: fileName, atomically: true, encoding: String.Encoding.utf8)
            
            return true
            
        } catch {
        
            return false
        }
        
        
    }
    
    func cleanUpRows(file: String) -> String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }

    func convertCSV(file: String){
        let rows = cleanUpRows(file: file).components(separatedBy: "\n")
        
        if rows.count > 0 {
             data = []
            columnTitles = getStringFieldsforRow(row: rows.first!, delimter: ",")
            for row in rows {
                let fields = getStringFieldsforRow(row: row, delimter: ",")
                if fields.count != columnTitles.count {continue}
                var dataRow = [String: String]()
                for (index, field) in fields.enumerated(){
                    let fieldName = columnTitles[index]
                    dataRow[fieldName] = field
                    
                }
                
                data += [dataRow]
                
            }
        } else {
            print("No dat in file")
        }
    }
    
    
    func printData() {
        convertCSV(file: textView.text)
        var tableString = ""
        var rowString = ""
        print("data: \(data)")
        
        for row in data {
            rowString = ""
            for fieldName in columnTitles {
                guard let field = row[fieldName] else {
                    print("field not found: \(fieldName)")
                    continue
                }
                
                rowString += String(format: "%@     ", field)
                
            }
            
            tableString += rowString + "\n"
            
            
        }
        
        textView.text = tableString
    }
    
    
    func getStringFieldsforRow(row: String, delimter: String) -> [String] {
        return row.components(separatedBy: delimter)
    }
    
    
    
    @IBAction func writeData(_ sender: Any) {
        
        if writeDataToFile(file: "Table_79") {
            
            print("data written")
        } else {
            print("data not written")
        }
        
    }
    
    @IBAction func readData(_ sender: Any) {
        
        textView.text = readDataFromFile(file: "Table_79")
        
        
    }
    @IBAction func reportData(_ sender: Any) {
        printData()
        
    }
    
    @IBAction func resetData(_ sender: Any) {
        
            textView.text = "Nope, no Pizza here"
        
    }
}

