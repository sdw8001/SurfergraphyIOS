//
//  NationListController.swift
//  SurferGraphy
//
//  Created by 손성빈 on 2018. 8. 9..
//  Copyright © 2018년 surfergraphy. All rights reserved.
//

import UIKit

class NationListController: UIViewController, UITableViewDataSource, UITableViewDelegate, CollapsibleTableViewHeaderDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private var nations: [Nation] = []
    
    var selectedNation: ((Type?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nations.append(Nation(name: "SOUTH KOREA", regions: [Region(name: "East Coast", image: nil, type: Type.KOEC), Region(name: "South Coast", image: nil, type: Type.KOSC), Region(name: "Jeju Island", image: nil, type: Type.KOJI), Region(name: "West Coast", image: nil, type: Type.KOWC)], image: #imageLiteral(resourceName: "ko.png"), collapsed: true, type: nil))
        
        nations.append(Nation(name: "JAPAN", regions: [], image: #imageLiteral(resourceName: "jp.png"), collapsed: true, type: Type.JP))
        
        nations.append(Nation(name: "CHINA", regions: [], image: #imageLiteral(resourceName: "cn.png"), collapsed: true, type: Type.CN))
        
        nations.append(Nation(name: "INDONESIA", regions: [], image: #imageLiteral(resourceName: "id.png"), collapsed: true, type: Type.ID))
        
        nations.append(Nation(name: "PHILPPINES", regions: [], image: #imageLiteral(resourceName: "ph.png"), collapsed: true, type: Type.PH))
        
        nations.append(Nation(name: "TAIWAN", regions: [], image: #imageLiteral(resourceName: "tw.png"), collapsed: true, type: Type.TW))
        
        nations.append(Nation(name: "USA", regions: [], image: #imageLiteral(resourceName: "us.png"), collapsed: true, type: Type.US))
        
        nations.append(Nation(name: "HAWAII", regions: [], image: #imageLiteral(resourceName: "us.png"), collapsed: true, type: Type.USHW))
        
        nations.append(Nation(name: "AUSTRALIA", regions: [], image: #imageLiteral(resourceName: "au.png"), collapsed: true, type: Type.AU))
        
        nations.append(Nation(name: "Other Countries", regions: [], image: #imageLiteral(resourceName: "camera.png"), collapsed: true, type: Type.ETC))
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.estimatedSectionHeaderHeight = 100
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NationCell", bundle: nil), forCellReuseIdentifier: "NationCell")
        tableView.register(UINib(nibName: "NationHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "NationHeader")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nations[section].collapsed ? 0 : nations[section].regions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NationHeader") as! CollapsibleTableViewHeader
        
        header.titleLabel.text = nations[section].name
        header.imageViewNation.image = nations[section].image
        header.setCollapsed(collapsed: nations[section].collapsed)
        header.section = section
        header.addGesture()
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NationCell") as! NationCell
        cell.labelTitle.text = nations[indexPath.section].regions[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return nations[(indexPath as NSIndexPath).section].collapsed ? 0 : UITableViewAutomaticDimension
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.delegate?.selectedNation(nationCode: nations[indexPath.section].regions[indexPath.row].type?.getType())
        selectedNation?(nations[indexPath.section].regions[indexPath.row].type)
    }
    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        if nations[section].regions.count != 0 {
            let collapsed = !nations[section].collapsed
            
            nations[section].collapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            // Reload the whole section
            tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        }
        else {
            //self.delegate?.selectedNation(nationCode: nations[section].type?.getType())
            selectedNation?(nations[section].type)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
