import Foundation

enum Settings: String {
    case summaryLines = "PREF_SUMMARY_LINES_COUNT"
    case searchPreferences = "PREF_SEARCH"
    case weeklyNotifications = "PREF_NOTIFICATIONS"

    var key: String { rawValue }
}
