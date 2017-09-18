//
//  ViewControllerFactory.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class ViewControllerFactory: NSObject {

    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    class func initialVC() -> UIViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "OverviewVC")
    }

    class func scheduleVC() -> UIViewController {
        return mainStoryboard().instantiateViewController(withIdentifier: "ScheduleVC")
    }
}
