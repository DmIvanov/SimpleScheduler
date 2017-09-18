//
//  ScheduleDataModel.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

class ScheduleDataModel: NSObject {

    private(set) var beginDate: Date!
    private(set) var endDate: Date!
    private(set) var frequency: ScheduleFrequency!

    private let dataSource: DataSource
    private var originalEvent: Event?

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    func setEvent(event: Event?) {
        originalEvent = event
    }

    func reset() {
        if originalEvent != nil {
            beginDate = originalEvent!.begin
            endDate = originalEvent!.end
            frequency = originalEvent!.frequency
        } else {
            beginDate = Date().beginningOfDay()
            endDate = beginDate
            frequency = .once
        }
    }

    func setBeginDate(date: Date) {
        beginDate = date.beginningOfDay()
        recalculateEndDate()
    }

    func setEndDate(date: Date) {
        endDate = date.beginningOfDay()
    }

    func beginDateFormatted() -> String {
        return dateFormatter.string(from: beginDate)
    }

    func endDateFormatted() -> String {
        return dateFormatter.string(from: endDate)
    }

    func setFrequency(frequency: ScheduleFrequency) {
        self.frequency = frequency
        recalculateEndDate()
    }

    func recalculateEndDate() {
        endDate = frequency.endDate(fromDate: beginDate)
    }

    func saveEvent() {
        var eventId: String? = nil
        if originalEvent != nil {
            eventId = originalEvent!.id
        }
        let newEvent = Event(
            begin: beginDate,
            end: endDate,
            frequency: frequency,
            id: eventId
        )
        dataSource.addEvent(event: newEvent)
    }
}


enum ScheduleFrequency: String {

    case once = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"

    static func amountOfOptions() -> Int {
        return 4
    }

    static func option(idx: Int) -> ScheduleFrequency {
        switch idx {
        case 1:     return .daily
        case 2:     return .weekly
        case 3:     return .monthly
        default:    return .once
        }
    }

    func index() -> Int {
        switch self {
        case .daily:    return 1
        case .weekly:   return 2
        case .monthly:  return 3
        default:        return 0
        }
    }

    func endDate(fromDate: Date) -> Date {
        switch self {
        case .daily:    return Calendar.current.date(byAdding: .day, value: 1, to: fromDate)!
        case .weekly:   return Calendar.current.date(byAdding: .weekOfYear, value: 1, to: fromDate)!
        case .monthly:  return Calendar.current.date(byAdding: .month, value: 1, to: fromDate)!
        default:        return fromDate
        }
    }
}


extension Date {
    func beginningOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
}
