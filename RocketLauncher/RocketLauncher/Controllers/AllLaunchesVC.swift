//
//  AllLaunchesVC.swift
//  RocketLauncher
//
//  Created by Coskun Caner on 19.10.2020.
//  Copyright © 2020 Coskun Caner. All rights reserved.
//

import UIKit

class AllLaunchesVC:UIViewController {
    
    @IBOutlet weak var sliderContainer:UIView!
    @IBOutlet weak var tableView:UITableView!
    
    let cell_id = "AllLaunchesTVCell_id"
    let cell_height = CGFloat(66.0)
    
    var dataSource:[Launch]! = [Launch]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup table
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // register our custom cell
        let nib = UINib(nibName: "AllLaunchesTVCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cell_id)
        
        // Slider View
        sliderContainer.layer.cornerRadius = 4
        sliderContainer.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadPageData()
    }
    
    func reloadPageData() {
        // in this case it is from DataSouce,
        // no need to cal service again, it is already done in RootVC
        self.dataSource = DataModel.shared.context.allLaunches
        self.tableView.reloadData()
    }
}





// MARK: - TableViw Delegates
extension AllLaunchesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! AllLaunchesTVCell
        cell.item = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cell_height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let targetVC = storyboard?.instantiateViewController(withIdentifier: "LaunchDetailVC") as! LaunchDetailVC
        targetVC.item = dataSource[indexPath.row]
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}
