//
//  OverviewDataModel.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

class OverviewDataModel: NSObject {

    let dataSource: DataSource

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    func amount() -> Int {
        return dataSource.events.count
    }

    func model(idx: Int) -> OverviewCellModel? {
        guard let event = dataSource.event(idx: idx) else {return nil}
        return OverviewCellModel(event: event)
    }

    func removeEvent(index: Int) {
        dataSource.removeEvent(index: index)
    }
}
