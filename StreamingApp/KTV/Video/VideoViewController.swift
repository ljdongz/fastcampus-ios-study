//
//  VideoViewController.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import UIKit

class VideoViewController: UIViewController {
    
    // MARK: - 제어패널
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: - scroll
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var channelThumbnailImageView: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var recommendTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var portraitControlPannel: UIView!
    
    private var contentSizeObservation: NSKeyValueObservation?
    
    private var viewModel = VideoViewModel()
    private var isControlPannelHidden: Bool = true {
        didSet {
            self.portraitControlPannel.isHidden = self.isControlPannelHidden
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMdd"
        
        return formatter
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.channelThumbnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
        self.bindViewModel()
        self.viewModel.request()
    }
    
    private func bindViewModel() {
        self.viewModel.dataChangeHandler = { [weak self] video in
            self?.setupData(video)
        }
    }
    
    private func setupData(_ video: Video) {
        self.titleLabel.text = video.title
        self.channelThumbnailImageView.loadImage(url: video.channelImageUrl)
        self.channelNameLabel.text = video.channel
        self.updateDateLabel.text = Self.dateFormatter.string(from: Date(timeIntervalSince1970: video.uploadTimestamp))
        self.playCountLabel.text = "재생수 \(video.playCount)"
        self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
        self.recommendTableView.reloadData()
    }
    
    @IBAction func commentDidTapped(_ sender: Any) {
    }
}

extension VideoViewController {
    
    @IBAction func toggleControlPannel(_ sender: Any) {
        self.isControlPannelHidden.toggle()
    }
    
    @IBAction func closeDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func rewindDidTapped(_ sender: Any) {
    }
    
    @IBAction func playDidTapped(_ sender: Any) {
    }
    
    @IBAction func fastForwardDidTapped(_ sender: Any) {
    }
    
    @IBAction func moreDidTapped(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: false)
    }
    
    @IBAction func expandDidTapped(_ sender: Any) {
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    private func setupRecommendTableView() {
        self.recommendTableView.delegate = self
        self.recommendTableView.dataSource = self
        self.recommendTableView.rowHeight = HomeRecommendItemCell.height
        self.recommendTableView.register(
            UINib(nibName: HomeRecommendItemCell.identifier, bundle: nil),
            forCellReuseIdentifier: HomeRecommendItemCell.identifier
        )
        
        // tableView의 contentSize를 관찰 -> 값이 변경됨을 감지 -> 높이 변경
        self.contentSizeObservation = self.recommendTableView.observe(
            \.contentSize,
             changeHandler: { [weak self] tableView, _ in
                 self?.tableViewHeightConstraint.constant = tableView.contentSize.height
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.video?.recommends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeRecommendItemCell.identifier, for: indexPath)
        
        if let cell = cell as? HomeRecommendItemCell,
           let data = self.viewModel.video?.recommends[indexPath.row] {
            cell.setData(data, rank: indexPath.row + 1)
        }
        
        return cell
    }
}
