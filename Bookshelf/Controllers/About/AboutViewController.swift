import UIKit

final class AboutViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet weak var versionLabel: UILabel!

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        getAppVersion()
    }

    // MARK: - Private Methods

    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func getAppVersion() {
        let version = Bundle.main.versionNumber
        let bundle = Bundle.main.bundleNumber
        versionLabel.text = "\(version) (\(bundle))"
    }
}

extension Bundle {
    var versionNumber: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? String()
    }

    var bundleNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? String()
    }
}
