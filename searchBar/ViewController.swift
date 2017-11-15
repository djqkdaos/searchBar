//
//  ViewController.swift
//  searchBar
//
//  Created by D7703_22 on 2017. 11. 15..
//  Copyright © 2017년 D7703_22. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{

    let nameArr = ["a","b","c","d","e"]
    var twiceDic:[String:[String]]!//JSON을 파싱한 딕셔너리
    var twiceNames:[String]!            //key들만의 배열
    var filterdNames = [String]()
    var searchPhone: UISearchController!
    
    @IBOutlet var tableA: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let pathA = Bundle.main.path(forResource: "Twice2", ofType: "json")
        let dataA = try! Data(contentsOf: URL(fileURLWithPath: pathA!))
        self.twiceDic = try! JSONSerialization.jsonObject(with: dataA, options: JSONSerialization.ReadingOptions.mutableLeaves)as![String:[String]]
        self.twiceNames = Array(self.twiceDic.keys)
        
        for ss in twiceNames{
            print(ss)
        }
        self.searchPhone = ({
            
            let con = UISearchController(searchResultsController: nil)
            con.searchResultsUpdater = self
            con.dimsBackgroundDuringPresentation = false
            con.searchBar.sizeToFit()
            tableA.tableHeaderView = con.searchBar
            return con
            
        })()
        self.tableA.register(UITableViewCell.self, forCellReuseIdentifier: "Reuse")//cell을 등록
        self.tableA.dataSource = self
        self.tableA.delegate = self
        
 
        
    }
    func updateSearchResults(for searchController: UISearchController){
        filterdNames.removeAll(keepingCapacity: false)
        let predicateA = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let arrayf = (twiceNames as NSArray).filtered(using: predicateA)
        
        filterdNames = arrayf as! [String]
        self.tableA.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchPhone.isActive ? self.filterdNames.count : self.twiceNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath)
        cell.textLabel?.text = searchPhone.isActive ? self.filterdNames[indexPath.row] : self.twiceNames[indexPath.row]
        
        return cell
    }


}

