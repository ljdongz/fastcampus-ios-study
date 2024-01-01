//
//  VideoViewControllerContainer.swift
//  KTV
//
//  Created by 이정동 on 1/2/24.
//

import Foundation

protocol VideoViewControllerContainer {
    var videoViewController: VideoViewController? { get }
    func presentCurrentViewController()
}
