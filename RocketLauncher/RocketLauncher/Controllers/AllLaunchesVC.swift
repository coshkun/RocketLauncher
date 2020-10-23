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
    
    // Slider Props ////////////////////////
    var sliderCollVC:MainSliderCollVC!
    var slideTimer:Timer!
    let kSliderShowDelay:TimeInterval = 5.0
    // /////////////////////////////////////
    
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
        
        createSliderWith(sliderContainer)
        reloadSlides()
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
    
    func reloadSlides() {
        Services.main.getUpcomingLaunches { (response, message) in
            ErrorManager.main.handleStatesAsync(response?.result, message: message) {
                // Store Data And Push to Slider
                self.sliderCollVC.dataItems = response!.result
                self.sliderCollVC.collectionView.reloadData()
                
                // set action for touch events
                self.sliderCollVC.action_touchUpInside = { indexPath in
                    guard let targetVC = self.storyboard?.instantiateViewController(withIdentifier: "LaunchDetailVC") as? LaunchDetailVC else {return}
                    targetVC.item = self.sliderCollVC.dataItems[indexPath.item]
                    self.navigationController?.pushViewController(targetVC, animated: true)
                }
            }
        }
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




















// MARK: - Slider Extention
extension AllLaunchesVC {
    func createSliderWith(_ container:UIView) {
        //Create Slider //////////////////////
        let flowLayout2 = UICollectionViewFlowLayout()
        flowLayout2.scrollDirection = .horizontal
        flowLayout2.minimumLineSpacing = 0
        flowLayout2.minimumInteritemSpacing = 0
        sliderCollVC = MainSliderCollVC(collectionViewLayout: flowLayout2)
        sliderCollVC.container = container
        
        addChild(sliderCollVC)
        
        sliderCollVC.view.frame = CGRect(x: 0, y: 0, width: container.bounds.width, height: container.bounds.height)
        sliderCollVC.view.layer.cornerRadius = 12
        sliderCollVC.view.layer.masksToBounds = true
        sliderCollVC.view.clipsToBounds = true
        
        
        container.addSubview(sliderCollVC.view) //.addSubview(newsCollVC.view)
        sliderCollVC.didMove(toParent: self)
        
        container.addConstraintsWithFormat(format: "H:|-0-[v0]-0-|", views: sliderCollVC.view)
        container.addConstraintsWithFormat(format: "V:|-0-[v0]-0-|", views: sliderCollVC.view)
        ////////////////////////////////////////////// Slider Initialized
    }
}




/////////////////////////////////////////////
// MARK: - MainVC Slider Collection Controller
//
class MainSliderCollVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cell_id = "MainSliderCollVCCell_id"
    var cell_size:CGSize = CGSize(width: 288, height: 128) //overrides this, see delegates
    var container:UIView!
    
    var dataItems:[Launch]! = [Launch]()
    
    var action_touchUpInside: ((IndexPath)->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        //register Custom Cell
        collectionView.register(UINib(nibName: "MainSliderCollVCCell", bundle: nil), forCellWithReuseIdentifier: cell_id)
        
        cell_size = CGSize(width: container.frame.width, height: container.frame.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cell_size = CGSize(width: container.bounds.width, height: container.frame.height)
    }
    
    
    // Data Delegates
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell_id, for: indexPath) as! MainSliderCollVCCell
        cell.item = dataItems[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deselectItem(at: indexPath, animated: true)
        
        // handle click events asyn
        DispatchQueue.main.async { self.action_touchUpInside?(indexPath) }
    }
    
    // Layout Delegates
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cell_size
    }
    
    func goToNextSlide() {
        guard dataItems.count > 0 else {return}
        
        guard let currentCell = collectionView.visibleCells.first as? MainSliderCollVCCell,
              var currentIndex = ( dataItems.firstIndex { $0.flightNumber == currentCell.item.flightNumber } )
        else {return}
        
        currentIndex += 1
        if currentIndex < dataItems.count {
            //jumt next
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        } else {
            //go to first
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        }
    }
    
    func goToPreviousSlide() {
        guard dataItems.count > 0 else {return}
        
        guard let currentCell = collectionView.visibleCells.first as? MainSliderCollVCCell,
        var currentIndex = ( dataItems.firstIndex { $0.flightNumber == currentCell.item.flightNumber } ) // $0.id
        else {return}
        
        currentIndex -= 1
        if currentIndex >= 0 {
            //jumt previous
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        } else {
            //go to last
            let indexPath = IndexPath(item: dataItems.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
        }
    }
}
