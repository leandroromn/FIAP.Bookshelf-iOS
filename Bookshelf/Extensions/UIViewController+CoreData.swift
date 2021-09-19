import CoreData
import UIKit

extension UIViewController {
    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("The shared delegate instance is not an AppDelegate class.")
        }
        return appDelegate.persistentContainer.viewContext
    }
}
