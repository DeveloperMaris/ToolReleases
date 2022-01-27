//
//  LocalNotificationController.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 17/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Foundation
import ToolReleasesCore
import UserNotifications

struct LocalNotificationProvider {
    private static let notificationID = "tool-releases-new-versions-available"
    
    private let center: UNUserNotificationCenter
    private let delegateQueue: DispatchQueue

    init(center: UNUserNotificationCenter = .current(), delegateQueue: DispatchQueue = .main) {
        self.center = center
        self.delegateQueue = delegateQueue
    }

    func addNotification(about tools: [Tool], completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                requestNotifications { success in
                    if success {
                        placeNotification(for: tools, completion: completion)
                    } else {
                        delegateQueue.async {
                            completion(false)
                        }
                    }
                }

            case .authorized:
                placeNotification(for: tools, completion: completion)

            default:
                delegateQueue.async {
                    completion(false)
                }
            }
        }
    }

    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
}

private extension LocalNotificationProvider {
    func requestNotifications(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }

    func placeNotification(for tools: [Tool], completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = "New versions available!"
        content.sound = .default

        switch tools.count {
        case 0:
            assertionFailure("Do not display notification when there are no new tools.")
            delegateQueue.async {
                completion(false)
            }

        case 1:
            content.subtitle = "\(tools[0].shortTitle)"

        case 2:
            content.subtitle = "\(tools[0].shortTitle) and \(tools[1].shortTitle)"

        default:
            content.subtitle = "\(tools[0].shortTitle), \(tools[1].shortTitle) and more..."
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let id = makeNotificationID(for: tools)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request) { error in
            delegateQueue.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func makeNotificationID(for tools: [Tool]) -> String {
        "\(Self.notificationID)-\(tools.hashValue)"
    }
}
