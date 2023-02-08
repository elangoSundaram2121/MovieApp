//
//  Coordinator.swift
//  MovieApp
//
//  Created by esundaram esundaram on 04/02/23.
//

import Foundation
import UIKit

/**
 Defines the set of requirements that needs to be implemented by any object that wants to act as a Coordinator for navigating
 between screens
 */
public protocol Coordinator: AnyObject {
    /**
     Represents the coordinator which spawned the current coordinator (self)
     - Important: If this is the root coordinator, this property will be nil

     For Example, if our Navigation starts with **Coordinator1**, the **Coordinator1**'s **parentCoordinator** will be nil. However, if the **Coordinator1** was created by **Coordinator0**, **Coordinator0** will be **Coordinator1**'s **parentCoordinator**.
     */
    var parentCoordinator: Coordinator? { get set }

    /**
     Contains a list of child coordinator spawned by the current coordinator (self)

     -Important: If a particular coordinator spawns a new coordinator as a child, it will be added to **childCoordinators** array, all the coordinators spawned by a particular coordinator will be available in this array.
     */
    var childCoordinators: [Coordinator] { get set }

    /**
     Method which will start the navigation flow of the Coordinator by pushing the screen for which the current coordinator is responsible for handling the navigation

     -Important: For Example, **CoordinatorA** is the coordinator for **Screen A**, so when start is called on **CoordinatorA**, the **CoordinatorA** will create the **Screen A** instance and adds to navigation stack and displays the **Screen A**
     */
    func start()
}

public extension Coordinator {



}
