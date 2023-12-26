//
//  HomeRecommendContainerCell.swift
//  KTV
//
//  Created by 이정동 on 12/19/23.
//

import UIKit

protocol HomeRecommendContainerCellDelegate: AnyObject {
    func homeRecommendContainerCell(_ cell: HomeRecommendContainerCell, didSelectItemAt index: Int)
    func homeRecommendContainerCellFoldChanged(_ cell: HomeRecommendContainerCell)
}

class HomeRecommendContainerCell: UITableViewCell {
    
    static let identifier = "HomeRecommendContainerCell"
    
    static func height(viewModel: HomeRecommendViewModel) -> CGFloat {
        let top: CGFloat = 84 - 6 // TableView Top에서 첫 번째 Cell Top까지 거리 - cell의 상단 여백
        let bottom: CGFloat = 68 - 6 // 마지막 Cell Bottom에서 TableView Bottom까지 거리 - cell의 하단 여백
        let footerInset: CGFloat = 51 // container.bottom -> content.bottom 까지의 여백
        
        // label, tableView, foldButton, 여백 등을 모두 포함한 높이
        return HomeRecommendItemCell.height * CGFloat(viewModel.itemCount) + top + bottom + footerInset
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var foldButton: UIButton!
    
    weak var delegate: HomeRecommendContainerCellDelegate?
    
    private var viewModel: HomeRecommendViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor(resource: .strokeLight).cgColor
        
        setupTableView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(
            UINib(nibName: HomeRecommendItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendItemCell.identifier
        )
        self.tableView.rowHeight = HomeRecommendItemCell.height
    }
    
    func setViewModel(_ viewModel: HomeRecommendViewModel) {
        self.viewModel = viewModel
        self.setButtonImage(viewModel.isFolded)
        self.tableView.reloadData()
        
        self.viewModel?.foldChanged = { [weak self] isFolded in
            self?.setButtonImage(isFolded)
            self?.tableView.reloadData()
        }
    }
    
    private func setButtonImage(_ isFolded: Bool) {
        let imageName: String = isFolded ? "unfold" : "fold"
        self.foldButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func foldButtonDidTapped(_ sender: Any) {
        self.viewModel?.toggleFoldState()
        self.delegate?.homeRecommendContainerCellFoldChanged(self)
    }
    
}

extension HomeRecommendContainerCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.itemCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
        
        if let cell = cell as? HomeRecommendItemCell,
           let data = self.viewModel?.recommends?[indexPath.row] {
            cell.setData(data, rank: indexPath.row + 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.homeRecommendContainerCell(self, didSelectItemAt: indexPath.row)
    }
}
