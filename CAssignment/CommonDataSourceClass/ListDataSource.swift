//
//  ListDataSource.swift
//  MVVMDemo
//
//  Created by Optimum  on 25/4/20.
//  Copyright © 2020 Optimum . All rights reserved.
//

import UIKit


class ListDataSource<Model>: NSObject , UITableViewDataSource  {
typealias CellConfigurator = (Model, UITableViewCell , Int) -> Void
    
    var models: [Model]!
    var headerView : UITableViewHeaderFooterView?
   private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator

    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
   
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )

        cellConfigurator(model, cell , indexPath.row)

        return cell
    }
    
    
}
