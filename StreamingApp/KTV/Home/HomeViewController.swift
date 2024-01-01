//
//  HomeViewController.swift
//  KTV
//
//  Created by 이정동 on 12/18/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let homeViewModel: HomeViewModel = .init()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.bindViewModel()
        self.homeViewModel.requestData()
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(
            UINib(nibName: HomeHeaderCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeHeaderCell.identifier
        )
        
        self.tableView.register(
            UINib(nibName: HomeVideoCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeVideoCell.identifier
        )
        
        self.tableView.register(
            UINib(nibName: HomeRankingContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRankingContainerCell.identifier)
        
        self.tableView.register(
            UINib(nibName: HomeRecentWatchContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecentWatchContainerCell.identifier
        )
        
        self.tableView.register(
            UINib(nibName: HomeRecommendContainerCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendContainerCell.identifier
        )
        
        self.tableView.register(
            UINib(nibName: HomeFooterCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeFooterCell.identifier
        )
        
        self.tableView.showsVerticalScrollIndicator = false
    }

    private func bindViewModel() {
        self.homeViewModel.dataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func presentVideoViewController() {
        if let vc = (self.tabBarController as? VideoViewControllerContainer)?.videoViewController {
            (self.tabBarController as? VideoViewControllerContainer)?.presentCurrentViewController()
        } else {
            let vc = VideoViewController()
            vc.delegate = self.tabBarController as? VideoViewControllerDelegate
            self.present(vc, animated: true)
        }
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        HomeSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .video:
            return 2
        case .ranking:
            return 1
        case .recentWatch:
            return 1
        case .recommend:
            return 1
        case .footer:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .header:
            return tableView.dequeueReusableCell(withIdentifier: HomeHeaderCell.identifier, for: indexPath)
        case .video:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeVideoCell.identifier, for: indexPath)
            if let cell = cell as? HomeVideoCell,
               let data = self.homeViewModel.home?.videos[indexPath.item] {
                cell.setData(data)
            }
            return cell
        case .ranking:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRankingContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRankingContainerCell,
               let data = self.homeViewModel.home?.rankings {
                cell.setData(data)
                cell.delegate = self
            }
            return cell
        case .recentWatch:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecentWatchContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecentWatchContainerCell,
               let data = self.homeViewModel.home?.recents {
                cell.setData(data)
                cell.delegate = self
            }
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendContainerCell.identifier, for: indexPath)
            
            if let cell = cell as? HomeRecommendContainerCell,
               let data = self.homeViewModel.home?.recommends {
                cell.setViewModel(homeViewModel.recommendViewModel)
                cell.delegate = self
            }
            return cell
        case .footer:
            return tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.identifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = HomeSection(rawValue: indexPath.section) else { return 0 }
        
        switch section {
        case .header:
            return HomeHeaderCell.height
        case .video:
            return HomeVideoCell.height
        case .ranking:
            return HomeRankingContainerCell.height
        case .recentWatch:
            return HomeRecentWatchContainerCell.height
        case .recommend:
            return HomeRecommendContainerCell.height(viewModel: homeViewModel.recommendViewModel)
        case .footer:
            return HomeFooterCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = HomeSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .header, .footer, .ranking, .recentWatch, .recommend:
            return
        case .video:
            self.presentVideoViewController()
        }
    }
}

extension HomeViewController: HomeRecommendContainerCellDelegate {
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell) {
        self.tableView.reloadData()
    }
    
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int) {
        self.presentVideoViewController()
    }
}

extension HomeViewController: HomeRankingContainerCellDelegate {
    func homeRankingContainerCell(_ cell: HomeRankingContainerCell, didSelectItemAt index: Int) {
        print(index)
    }
}

extension HomeViewController: HomeRecentWatchContainerCellDelegate {
    func homeRecentWatchContainerCell(_ cell: HomeRecentWatchContainerCell, didSelectItemAt index: Int) {
        print(index)
    }
    
    
}
