//
//  OverviewCell.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit


class OverviewCellModel: NSObject {

    let event: Event
    let begin: String
    let end: String

    init(event: Event) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        self.begin = formatter.string(from: event.begin)
        self.end = formatter.string(from: event.end)
        self.event = event
    }
}


class OverviewCell: UITableViewCell {

    @IBOutlet var beginLabel: UILabel!
    @IBOutlet var endLabel: UILabel!

    func setModel(model: OverviewCellModel) {
        beginLabel.text = "Begin: " + model.begin
        endLabel.text = "End: " + model.end
    }
}
