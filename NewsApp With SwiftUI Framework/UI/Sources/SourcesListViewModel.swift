//
//  SourcesListViewModel.swift
//  NewsApp With SwiftUI Framework
//
//  Created by Алексей Воронов on 20.06.2019.
//  Copyright © 2019 Алексей Воронов. All rights reserved.
//

import SwiftUI
import Combine

final class SourcesListViewModel: BindableObject {
    private let apiProvider: APIProviderProtocol = APIProvider.shared
    
    private(set) var sources: Sources = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    var didChange = PassthroughSubject<SourcesListViewModel, Never>()
    
    func getSources() {
        apiProvider.performRequest(.getSources)
            .decode(type: SourcesResponse.self, decoder: Container.jsonDecoder)
            .map { $0.sources }
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] (sources) in
                self?.sources = sources
            })
            .receive(completion: Subscribers.Completion<Never>.finished)
    }
}
