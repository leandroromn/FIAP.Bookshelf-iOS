import UIKit

final class SettingsViewController: UITableViewController{
    // MARK: - Outlets

    @IBOutlet weak var summaryLinesStepper: UIStepper!
    @IBOutlet weak var summaryLinesLabel: UILabel!
    @IBOutlet weak var searchPreferencesSwitch: UISwitch!
    @IBOutlet weak var notificationsPreferencesSwitch: UISwitch!
    
    // MARK: - Properties

    let userDefaults = UserDefaults.standard
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationIdentifier = "com.romano.Bookshelf.weekly_reminder_notification"
    let kSummaryPreferencesKey = "PREF_SUMMARY_LINES_COUNT"
    let kSearchPreferencesKey = "PREF_SEARCH"
    let kNotificationsPreferencesKey = "PREF_NOTIFICATIONS"

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPreferences()
    }

    // MARK: - Private Methods

    private func loadPreferences() {
        let summaryLinesValue = userDefaults.double(forKey: kSummaryPreferencesKey)
        summaryLinesStepper.value = summaryLinesValue
        summaryLinesLabel.text = formatLinesText(summaryLinesValue)

        searchPreferencesSwitch.isOn = userDefaults.bool(forKey: kSearchPreferencesKey)
        notificationsPreferencesSwitch.isOn = userDefaults.bool(forKey: kNotificationsPreferencesKey)
    }

    private func formatLinesText(_ value: Double) -> String {
        "\(String(format: "%.f", value)) linhas"
    }

    private func scheduleLocalNotification() {
        notificationCenter.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Lembrete semanal"
        content.body = "Mantenha sua lista de livros atualizada. Adicione ou altere um livro!"

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(hour: 10, weekday: 2),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: notificationIdentifier,
            content: content,
            trigger: trigger
        )

        notificationCenter.add(request)
    }

    // MARK: - Actions

    @IBAction func changeSummaryLinesCount(_ sender: UIStepper) {
        summaryLinesLabel.text = formatLinesText(sender.value)
        userDefaults.set(sender.value, forKey: kSummaryPreferencesKey)
    }

    @IBAction func changeSearchPreferencesValue(_ sender: UISwitch) {
        userDefaults.setValue(sender.isOn, forKey: kSearchPreferencesKey)
    }

    @IBAction func changeNotificationsPreferencesValue(_ sender: UISwitch) {
        userDefaults.setValue(sender.isOn, forKey: kNotificationsPreferencesKey)

        if sender.isOn {
            scheduleLocalNotification()
        } else {
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
}
