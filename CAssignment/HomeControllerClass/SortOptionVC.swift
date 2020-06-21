//
//  SortOptionVC.swift
//  CAssignment
//
//  Created by Optimum  on 19/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit

class SortOptionVC: UIViewController {
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedOption = 0
    var listDataSource : ListDataSource<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUILayers()
        self.addSwipeDownGesture()
        self.updateUIwithResult()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.listDataSource != nil
        {
            self.tableView.reloadData()
        }
    }
    // MARK: Add Swipe Gesture for Dismiss the View
    func addSwipeDownGesture ()
    {
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(swipeleftGesture))
        swipedown.direction = .down
        self.view.addGestureRecognizer(swipedown)
    }
    @objc func swipeleftGesture ()
    {
        (self.parent as! HomeVC).hideChildViewController()
        
    }
    // MARK: Methods to update UI with Data
    func updateUIwithResult()
    {
        listDataSource = ListDataSource(
            models:["Level" ,"Capacity" ,"Availability"],
            reuseIdentifier: "SortOptionCell"
        ) { message, cell , row in
            
            let sortCell = cell as! SortOptionCell
            sortCell.titleLbl.text = (message as! String)
            sortCell.selectedImgVw.layer.cornerRadius = 10
            if row == self.selectedOption
            {
                sortCell.selectedImgVw.backgroundColor = #colorLiteral(red: 0.3261396289, green: 0.7596032619, blue: 0.9830271602, alpha: 1)
                sortCell.selectedImgVw.layer.borderWidth = 0
            }
            else
            {
                sortCell.selectedImgVw.backgroundColor = UIColor.clear
                sortCell.selectedImgVw.layer.borderColor = #colorLiteral(red: 0.7910789847, green: 0.7910977006, blue: 0.791087687, alpha: 1)
                sortCell.selectedImgVw.layer.borderWidth = 2
            }
            
            cell.selectionStyle = .none
        }
        self.tableView.dataSource = self.listDataSource
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    // MARK: Functions to customize subview layers
    func setUILayers()
    {
        self.resetBtn.layer.cornerRadius = 20
        self.applyBtn.layer.cornerRadius = 20
        self.view.layer.cornerRadius = 10
        self.view.dropShadow()
    }
}
// MARK: IBActions
extension SortOptionVC  {
    @IBAction func resetBtnClicked (sender:AnyObject)
    {
        (self.parent as! HomeVC).sortRecords(type: .level)
        (self.parent as! HomeVC).hideChildViewController()
    }
    @IBAction func applyBtnClicked (sender:AnyObject)
    {
        (self.parent as! HomeVC).sortRecords(type: SortOptions(rawValue: selectedOption)!)
        (self.parent as! HomeVC).hideChildViewController()
        
    }
}

extension SortOptionVC  {
    struct Storyboard {
        static let ControllerID = "SortOptionVC"
    }
    
    static func instantiate() -> SortOptionVC{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: Storyboard.ControllerID) as! SortOptionVC
    }
}
// MARK: UITableview Delegate Functions
extension SortOptionVC : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedOption = indexPath.row
        self.tableView.reloadData()
    }
}
