//
//  DataSource.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation


class DataSource: NSObject {

    // MARK: - Properties
    private(set) var events = [Event]()


    // MARK: - Lyfecycle
    override init() {
        super.init()
        retrieveEvents()
    }


    // MARK: - Public
    func addEvent(event: Event) {
        if let idx = eventIdx(event: event) {
            events[idx] = event
        } else {
            events.append(event)
        }
        orderEvents()
        saveEvents()
    }

    func removeEvent(event: Event) {
        guard let idx = eventIdx(event: event) else {return}
        removeEvent(index: idx)
    }

    func removeEvent(index: Int) {
        guard index >= 0 && index < events.count else {return}
        events.remove(at: index)
        orderEvents()
        saveEvents()
    }

    func event(idx: Int) -> Event? {
        guard idx >= 0 && idx < events.count else {return nil}
        return events[idx]
    }


    // MARK: Persistence
    private func saveEvents() {
        NSKeyedArchiver.archiveRootObject(events, toFile: EventsArchiveURL.path)
    }

    private func retrieveEvents() {
        if let savedEvents = NSKeyedUnarchiver.unarchiveObject(withFile: EventsArchiveURL.path) as? [Event] {
            events = savedEvents
        }
    }


    // MARK: - Private
    private func eventIdx(event: Event) -> Int? {
        return events.index { (collectionEvent) -> Bool in
            collectionEvent.id == event.id
        }
    }

    private func orderEvents() {
        events.sort { (event1, event2) -> Bool in
            if event1.begin.timeIntervalSince1970 == event2.begin.timeIntervalSince1970 {
                return event1.end.timeIntervalSince1970 < event2.end.timeIntervalSince1970
            } else {
                return event1.begin.timeIntervalSince1970 < event2.begin.timeIntervalSince1970
            }
        }
    }
}


class Event: NSObject, NSCoding {

    // MARK: - Properties
    let begin: Date
    let end: Date
    let frequency: ScheduleFrequency
    let id: String


    // MARK: - Lyfecycle
    init(begin: Date, end: Date, frequency: ScheduleFrequency, id: String? = nil) {
        self.begin = begin
        self.end = end
        self.frequency = frequency
        if id != nil {
            self.id = id!
        } else {
            self.id = UUID().uuidString
        }
    }


    // MARK: - NSCodinf conformance
    required convenience init?(coder aDecoder: NSCoder) {
        let begin = aDecoder.decodeObject(forKey: PropertyKey.begin) as! Date
        let end = aDecoder.decodeObject(forKey: PropertyKey.end) as! Date
        let frequency = aDecoder.decodeObject(forKey: PropertyKey.frequency) as! String
        let id = aDecoder.decodeObject(forKey: PropertyKey.id) as! String
        self.init(begin: begin, end: end, frequency: ScheduleFrequency(rawValue: frequency)!, id: id)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(begin, forKey: PropertyKey.begin)
        aCoder.encode(end, forKey: PropertyKey.end)
        aCoder.encode(frequency.rawValue, forKey: PropertyKey.frequency)
        aCoder.encode(id, forKey: PropertyKey.id)
    }
}


// ----------------------------------------------------------------------------
// MARK: - Helper for persisting (NSCoding)
// ----------------------------------------------------------------------------
struct PropertyKey {
    static let begin = "begin"
    static let end = "end"
    static let frequency = "frequency"
    static let id = "id"
}


let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
let EventsArchiveURL = DocumentsDirectory.appendingPathComponent("Events")
