//
//  MainInteractor.swift
//  SimpleScheduler
//
//  Created by Dmitrii on 16/09/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import UIKit

class MainInteractor: NSObject {

    // MARK: - Properties
    private weak var window: UIWindow!
    private let dataSource = DataSource()


    // MARK: - Lyfecycle
    init(mainWindow: UIWindow) {
        window = mainWindow
    }


    // MARK: - Public
    func appDidLaunched(options: [UIApplicationLaunchOptionsKey: Any]?) {
        let initialVC = ViewControllerFactory.initialVC() as! OverviewTableViewController
        initialVC.setDataSource(dataSource: dataSource)
        let nc = UINavigationController(rootViewController: initialVC)
        window.rootViewController = nc
        window.makeKeyAndVisible()
    }
}
