//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests
protocol AnalyticsService: AnyObject {
    
    func trackEvent(name: String, parameters: [String: String])
    func getEvents(name: String?, from: Date?, to: Date?) -> [AnalyticsEvent]
}

final class AnalyticsServiceImpl {
    
    private var events: [AnalyticsEvent] = []
    
    // MARK: - Init
    
    init() {
        
    }
}

extension AnalyticsServiceImpl: AnalyticsService {
    
    func trackEvent(name: String, parameters: [String: String]) {
        let event = AnalyticsEvent(
            name: name,
            parameters: parameters,
            date: .now
        )
        
        events.append(event)
    }
    
    func getEvents(name: String?, from: Date?, to: Date?) -> [AnalyticsEvent] {
        return events.filter { event in
            let matchesName = name == nil || event.name == name
            let matchesFrom = from == nil || event.date >= from!
            let matchesTo = to == nil || event.date <= to!
            return matchesName && matchesFrom && matchesTo
        }
    }
}
