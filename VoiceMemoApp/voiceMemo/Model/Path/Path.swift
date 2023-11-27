//
//  Path.swift
//  voiceMemo
//

import Foundation

class PathModel: ObservableObject {
    
    @Published var paths: [PathType]
    
    init(path: [PathType] = []) {
        self.paths = path
    }
}
