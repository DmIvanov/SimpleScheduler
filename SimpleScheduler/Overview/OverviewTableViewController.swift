//
//  OverviewTableViewController.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class OverviewTableViewController: UITableViewController {

    // MARK: - Properties
    private var vcDataModel: OverviewDataModel!


    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    // MARK: - Public
    func setDataSource(dataSource: DataSource) {
        vcDataModel = OverviewDataModel(dataSource: dataSource)
    }

    // MARK: - Private
    private func openScheduleVC(event: Event? = nil) {
        let scheduleVC = ViewControllerFactory.scheduleVC() as! ScheduleViewController
        scheduleVC.setDataSource(dataSource: vcDataModel.dataSource)
        scheduleVC.setEvent(event: event)
        navigationController?.pushViewController(scheduleVC, animated: true)
    }


    // MARK: - Actions
    @IBAction func addButtonPressed() {
        openScheduleVC()
    }


    // MARK: - Table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vcDataModel.amount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCellId", for: indexPath) as! OverviewCell
        if let model = vcDataModel.model(idx: indexPath.row) {
            cell.setModel(model: model)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = vcDataModel.model(idx: indexPath.row) {
            openScheduleVC(event: model.event)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            vcDataModel.removeEvent(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
