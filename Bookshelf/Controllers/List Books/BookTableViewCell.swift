import UIKit

final class BookTableViewCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageBook: UIImageView!

    // MARK: - Properties

    let userDefaults = UserDefaults.standard
    var summaryLinesPreferencesValue: Int {
        Int(userDefaults.double(forKey: Settings.summaryLines.key))
    }

    // MARK: - Methods

    func configureContent(for book: Book) {
        loadPreferences()
        imageBook.image = book.image as? UIImage
        titleLabel.text = book.title
        summaryLabel.text = book.summary
    }
}

// MARK: - Preferences

extension BookTableViewCell: PreferencesProtocol {
    func loadPreferences() {
        summaryLabel.numberOfLines = summaryLinesPreferencesValue
    }
}
