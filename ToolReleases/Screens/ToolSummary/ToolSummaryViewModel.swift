//
//  ToolSummaryViewModel.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 28/05/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Combine
import Foundation
import ToolReleasesCore

extension ToolSummaryView {
    class ViewModel: ObservableObject {
        private let provider: ToolProvider
        private var cancellables: Set<AnyCancellable> = []

        @Published private(set) var tools: [Tool]
        @Published private(set) var isRefreshing: Bool
        @Published var keywords: String
        @Published var filter: Filter
        @Published var isKeywordFilterEnabled: Bool

        let timer: Publishers.Autoconnect<Timer.TimerPublisher>
        var lastRefresh: Date? { provider.lastRefresh }

        init(provider: ToolProvider) {
            self.provider = provider
            self.tools = []
            self.filter = .all
            self.keywords = ""
            self.isRefreshing = false
            self.timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
            self.isKeywordFilterEnabled = false

            provider.$tools
                .map { [weak self] tools in
                    guard let self = self else { return [] }

                    return self.filter(
                        tools,
                        filter: self.filter,
                        includingKeywordFilter: self.isKeywordFilterEnabled,
                        by: self.keywords
                    )
                }
                .sink { [weak self] tools in
                    self?.tools = tools
                }
                .store(in: &cancellables)

            $keywords
                .dropFirst()
                .debounce(for: 0.3, scheduler: DispatchQueue.main)
                .map { [weak self] searchString in
                    guard let self = self else { return [] }

                    return self.filter(
                        self.provider.tools,
                        filter: self.filter,
                        includingKeywordFilter: self.isKeywordFilterEnabled,
                        by: String(searchString)
                    )
                }
                .sink { [weak self] tools in
                    self?.tools = tools
                }
                .store(in: &cancellables)

            $filter
                .dropFirst()
                .map { [weak self] filter in
                    guard let self = self else { return [] }

                    return self.filter(
                        self.provider.tools,
                        filter: filter,
                        includingKeywordFilter: self.isKeywordFilterEnabled,
                        by: self.keywords
                    )
                }
                .sink { [weak self] tools in
                    self?.tools = tools
                }
                .store(in: &cancellables)

            $isKeywordFilterEnabled
                .dropFirst()
                .map { [weak self] filterEnabled in
                    guard let self = self else { return [] }

                    return self.filter(
                        self.provider.tools,
                        filter: self.filter,
                        includingKeywordFilter: filterEnabled,
                        by: self.keywords
                    )
                }
                .sink { [weak self] tools in
                    self?.tools = tools
                }
                .store(in: &cancellables)

            provider.$isRefreshing
                .sink { [weak self] isRefreshing in
                    self?.isRefreshing = isRefreshing
                }
                .store(in: &cancellables)
        }

        func filter(
            _ tools: [Tool],
            filter: Filter,
            includingKeywordFilter: Bool = true,
            by keywords: String
        ) -> [Tool] {
            let keywordGroups = Search.transformKeywords(keywords)

            return tools
                .filtered(by: filter)
                .filter {
                    includingKeywordFilter && keywordGroups.isEmpty == false
                        ? $0.title.contains(keywordGroups)
                        : true
                }
                .sorted { $0.date > $1.date }
        }

        func fetch() {
            provider.fetch()
        }
    }
}

extension ToolSummaryView.ViewModel {
    enum Filter: CaseIterable, CustomStringConvertible {
        case all, beta, release

        public var description: String {
            switch self {
            case .all:
                return "All"
            case .beta:
                return "Beta"
            case .release:
                return "Released"
            }
        }
    }
}

extension Array where Element == Tool {
    func filtered(by filter: ToolSummaryView.ViewModel.Filter) -> [Element] {
        switch filter {
        case .all:
            return self
        case .beta:
            return self.filter { $0.isBeta || $0.isReleaseCandidate }
        case .release:
            return self.filter { $0.isRelease }
        }
    }
}
