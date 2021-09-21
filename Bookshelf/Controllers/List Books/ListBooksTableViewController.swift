import CoreData
import UIKit

final class ListBooksTableViewController: UITableViewController {
    // MARK: - Properties

    let cellIdentifier = "cell"
    let detailSegueIdentifier = "detailSegue"

    lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        let request: NSFetchRequest = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBooks()
        checkEmptyState()
    }

    // MARK: - Private Methods

    private func loadBooks() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func checkEmptyState() {
        guard let objects = fetchedResultsController.fetchedObjects else { return }
        if objects.isEmpty {
            let emptyTextLabel = UILabel()
            emptyTextLabel.text = "Cadastre seu primeiro livro! 📚☕️"
            emptyTextLabel.textAlignment = .center
            emptyTextLabel.font = .systemFont(ofSize: 14, weight: .semibold)
            emptyTextLabel.textColor = .secondaryLabel
            tableView.backgroundView = emptyTextLabel
        } else {
            tableView.backgroundView = nil
        }
    }

    // MARK: - Override Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == detailSegueIdentifier,
              let destination = segue.destination as? BookDetailViewController,
              let indexPath = tableView.indexPathForSelectedRow
        else { return }
        destination.book = fetchedResultsController.object(at: indexPath)
    }
}

// MARK: - Table View DataSource

extension ListBooksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }

        cell.configureContent(
            for: fetchedResultsController.object(at: indexPath)
        )

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteBook(at: indexPath)
        }
    }

    private func deleteBook(at indexPath: IndexPath) {
        let book = fetchedResultsController.object(at: indexPath)
        context.delete(book)

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - NSFetchedResultsController delegate

extension ListBooksTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        checkEmptyState()
    }
}
