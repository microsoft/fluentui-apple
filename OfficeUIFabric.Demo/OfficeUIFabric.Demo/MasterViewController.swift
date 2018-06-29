//
//  Copyright © 2018 Microsoft Corporation. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    // Register your control demos here
    let demos: [(title: String, controllerClass: UIViewController.Type)] = [
        ("MSButton", MSButtonController.self)
    ]

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.title = demos[indexPath.row].title
                controller.demoControllerClass = demos[indexPath.row].controllerClass
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = demos[indexPath.row].title
        return cell
    }
}
