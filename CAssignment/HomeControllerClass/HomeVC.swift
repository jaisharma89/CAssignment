//
//  ViewController.swift
//  CAssignment
//
//  Created by Optimum  on 16/6/20.
//  Copyright © 2020 Jai. All rights reserved.
//

import UIKit
import AnimatedField

class HomeVC: UIViewController , AnimatedFieldDelegate ,UITableViewDelegate
{
    @IBOutlet weak var dateTxtFld: AnimatedField!
    @IBOutlet weak var timeTxtFld: AnimatedField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    
    let childController = SortOptionVC.instantiate()
    var roomsViewModal : HomeViewModel!
    var listDataSource : ListDataSource<Any>!
    var statusBarHeight:CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomsViewModal = HomeViewModel()
        
        self.addTableHeaderView()
        self.setUpTextFieldWithPicker()
        self.customizeNavigationBar()
        
    }
    //MARK: Customize UI views Functions
    func addTableHeaderView()
    {
        self.tableView.isHidden = true
        self.messageLbl.isHidden = false
        self.tableView.delegate = self
        self.headerView.frame = CGRect(x:0,y:0,width: self.tableView.frame.size.width ,height: 30)
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = nil
        
    }
    func setUpTextFieldWithPicker()
    {
        var format = AnimatedFieldFormat()
        format.highlightColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        dateTxtFld.delegate = self
        dateTxtFld.format = format
        dateTxtFld.placeholder = "Date"
        dateTxtFld.tag = 2
        dateTxtFld.type = .datepicker(.date, Date(), Date(), nil, nil, "MMM d, yyyy")
        
        
        timeTxtFld.format = format
        timeTxtFld.delegate = self
        timeTxtFld.placeholder = "Timeslot"
        timeTxtFld.tag = 1
        timeTxtFld.type = .datepicker(.time, Date(), nil, nil, nil, "hh:mm a")
    }
    func updateUIwithResult()
    {
        listDataSource = ListDataSource(
            models:(roomsViewModal.records),
            reuseIdentifier: "RoomDetailCell"
        ) { message, cell , row in
            let roomCell = cell as! RoomDetailCell
            roomCell.nameLbl.text = (message as! RoomDetailModal).name
            roomCell.leveLbl.text = "Level " + ((message as! RoomDetailModal).level)
            roomCell.capacityLbl.text = "\((message as! RoomDetailModal).capacity)" + " Pax"
            roomCell.bgView.layer.cornerRadius = 5
            roomCell.availabilityLbl.text = "Not Available"
            roomCell.availabilityLbl.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
            if (message as! RoomDetailModal).isAvailable
            {
                (cell as! RoomDetailCell).availabilityLbl.text = "Available"
                (cell as! RoomDetailCell).availabilityLbl.textColor = #colorLiteral(red: 0.462745098, green: 0.7803921569, blue: 0.4588235294, alpha: 1)
            }
            cell.selectionStyle = .none
        }
        self.tableView.dataSource = self.listDataSource
        self.tableView.reloadData()
        self.childController.selectedOption = 0
        self.tableView.isHidden = false
        self.messageLbl.isHidden = true
    }
    func customizeNavigationBar()
    {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let img = UIImage(named: "ic_camera")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(cameraBtnClicked(sender:)))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @objc func cameraBtnClicked (sender : Any)
    {
        let controller = ScanneVC.init()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true) {
        }
    }
    //MARK: IBActions
    @IBAction func sortBtnClicked ()
    {
        self.showSortOptions()
    }
    func sortRecords (type:SortOptions)
    {
        self.roomsViewModal.sortby(type: type) { (sucess) in
            self.updateUIwithResult()
        }
    }
    //MARK: CallBack Functions for User Input changed
    func animatedFieldDidChange(_ animatedField: AnimatedField)
    {
        self.fetchNewRoomRecords()
        
    }
    //MARK: Function to fetch new records 
    func fetchNewRoomRecords ()
    {
       if !self.timeTxtFld.text!.isEmpty && !self.dateTxtFld.text!.isEmpty
       {
            roomsViewModal.records.removeAll()
            self.tableView.isHidden = true
            self.messageLbl.isHidden = false
            roomsViewModal.getRoomRecords(date: self.dateTxtFld.text!, time: self.timeTxtFld.text!) { (success, error) in
                if success
                {
                    DispatchQueue.main.async
                        {
                            self.updateUIwithResult()
                    }
                }
                else
                {
                    switch error {
                    case .noInternetConnection:
                        self.showErrorAlert(with: "The internet connection is lost", titile: "Error")
                        break
                    case .other:
                        self.showErrorAlert(with: "Somethig went wrong. Please try again Later", titile: "Oops!")
                        break
                    case .custom(let errorDesc):
                        print(errorDesc.localizedDescription)
                        self.showErrorAlert(with: errorDesc.localizedDescription, titile: "Error")
                        break
                    default:
                        print(error!)
                    }
                }
            }
        }
    }
}
//MARK: Show SortView Functions
extension HomeVC
{
    func showSortOptions ()
    {
        let screenSize = UIScreen.main.bounds.size
        self.addChild(childController)
        childController.view.frame = CGRect(x:0,y:screenSize.height,width: screenSize.width ,height: screenSize.height - (self.dateTxtFld.frame.origin.y + statusBarHeight ))
        view.addSubview(childController.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.childController.view.frame = CGRect(x: 0, y:(self.dateTxtFld.frame.origin.y + self.statusBarHeight), width: screenSize.width, height: self.childController.view.frame.height)
        }, completion:  { (success) in
        })
        
    }
    func hideChildViewController()
    {
        childController.willMove(toParent: nil)
        let screenSize = UIScreen.main.bounds.size
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.childController.view.frame = CGRect(x: 0, y:screenSize.height, width: screenSize.width, height: self.childController.view.frame.height)
        }, completion: { (success) in
            self.childController.view.removeFromSuperview()
            self.childController.removeFromParent()
        })
    }
}
//MARK: Show WebView Function
extension HomeVC: ScannerDelegate {
    func didScan(url: String?) {
        let webController = WebViewVC.init()
        webController.urlStr = url!
        self.navigationController?.pushViewController(webController, animated: true)
    }
    
}

