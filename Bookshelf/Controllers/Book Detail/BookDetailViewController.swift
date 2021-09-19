import UIKit

final class BookDetailViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    // MARK: - Properties

    var book: Book?

    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private Methods

    private func setupView() {
        bookImageView.image = book?.image as? UIImage
        titleLabel.text = book?.title
        summaryLabel.text = book?.summary

        if let rating = book?.rating {
            let ratingText = String(format: "%.2f", rating)
            ratingLabel.text = "Nota: \(ratingText)⭐️"
        }
    }

    // MARK: - Override Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? AddEditBookViewController else { return }
        destination.book = book
    }
}
