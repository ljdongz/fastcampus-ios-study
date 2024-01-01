//
//  VideoViewController.swift
//  KTV
//
//  Created by 이정동 on 12/27/23.
//

import UIKit
import AVKit

protocol VideoViewControllerDelegate: AnyObject {
    func videoViewController(
        _ videoViewController: VideoViewController,
        yPositionForMinimizeView height: CGFloat
    ) -> CGFloat
    
    func videoViewControllerDidMinimize(_ videoViewController: VideoViewController)
    func videoViewControllerNeedsMaximize(_ videoViewController: VideoViewController)
    func videoViewControllerDidTapClose(_ videoViewController: VideoViewController)
}

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
    @IBOutlet weak var landscapeControlPannel: UIView!
    
    @IBOutlet weak var landscapePlayButton: UIButton!
    @IBOutlet weak var landscapeTitleLabel: UILabel!
    
    @IBOutlet weak var playerView: PlayerView!
    
    @IBOutlet weak var seekbar: SeekBarView!
    
    @IBOutlet weak var landscapePlayTimeLabel: UILabel!
    @IBOutlet var playerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chattingView: ChattingView!
    var isLiveMode: Bool = false
    
    private var isMinimizeMode: Bool = false {
        didSet {
            self.minimizeView.isHidden = !self.isMinimizeMode
        }
    }
    
    @IBOutlet weak var minimizeView: UIView!
    
    @IBOutlet weak var minimizePlayerView: PlayerView!
    
    @IBOutlet weak var minimizeTitleLabel: UILabel!
    
    @IBOutlet weak var minimizeChannelLabel: UILabel!
    @IBOutlet weak var minimizePlayButton: UIButton!
    @IBOutlet weak var minimizeViewBottomConstraint: NSLayoutConstraint!
    
    private var pipController: AVPictureInPictureController?
    
    private var contentSizeObservation: NSKeyValueObservation?
    
    
    private var viewModel = VideoViewModel()
    private var isControlPannelHidden: Bool = true {
        didSet {
            if self.isLandscape(size: self.view.frame.size) {
                self.landscapeControlPannel.isHidden = self.isControlPannelHidden
            } else {
                self.portraitControlPannel.isHidden = self.isControlPannelHidden
            }
        }
    }
    
    weak var delegate: VideoViewControllerDelegate?
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMdd"
        
        return formatter
    }()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minimizePlayerView.delegate = self
        self.playerView.delegate = self
        self.seekbar.delegate = self
        self.chattingView.delegate = self
        self.channelThumbnailImageView.layer.cornerRadius = 14
        self.setupRecommendTableView()
        self.bindViewModel()
        self.viewModel.request()
        self.chattingView.isHidden = !self.isLiveMode
        
        self.setupPIPController()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.setEditing(false, animated: true)
        self.switchControlPannel(size: size)
        self.playerViewBottomConstraint.isActive = self.isLandscape(size: size)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setupPIPController() {
        guard
            AVPictureInPictureController.isPictureInPictureSupported(),
            let playerLayer = self.playerView.avPlayerLayer
        else {
            return
        }
        
        let pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        
        self.pipController = pipController
    }
    
    private func isLandscape(size: CGSize) -> Bool {
        size.width > size.height
    }
    
    private func bindViewModel() {
        self.viewModel.dataChangeHandler = { [weak self] video in
            self?.setupData(video)
        }
    }
    
    private func setupData(_ video: Video) {
        self.playerView.set(url: video.videoURL)
        self.playerView.play()
        self.titleLabel.text = video.title
        self.landscapeTitleLabel.text = video.title
        self.channelThumbnailImageView.loadImage(url: video.channelImageUrl)
        self.channelNameLabel.text = video.channel
        self.updateDateLabel.text = Self.dateFormatter.string(from: Date(timeIntervalSince1970: video.uploadTimestamp))
        self.playCountLabel.text = "재생수 \(video.playCount)"
        self.favoriteButton.setTitle("\(video.favoriteCount)", for: .normal)
        self.recommendTableView.reloadData()
    }
    
    @IBAction func commentDidTapped(_ sender: Any) {
        if self.isLiveMode {
            self.chattingView.isHidden = false
        }
    }
    
    
}

extension VideoViewController {
    @IBAction func minimizeViewCloseDidTapped(_ sender: Any) {
        self.delegate?.videoViewControllerDidTapClose(self)
    }
    
    @IBAction func maximize(_ sender: Any) {
        self.delegate?.videoViewControllerNeedsMaximize(self)
    }
}

extension VideoViewController {
    
    private func switchControlPannel(size: CGSize) {
        guard self.isControlPannelHidden == false else {
            return
        }
        
        self.landscapeControlPannel.isHidden = !self.isLandscape(size: size)
        self.portraitControlPannel.isHidden = self.isLandscape(size: size)
    }
    
    @IBAction func toggleControlPannel(_ sender: Any) {
        self.isControlPannelHidden.toggle()
    }
    
    @IBAction func closeDidTapped(_ sender: Any) {
        self.isMinimizeMode = true
        self.rotateScene(landscape: false)
        self.dismiss(animated: true)
    }
    
    @IBAction func rewindDidTapped(_ sender: Any) {
        self.playerView.rewind()
    }
    
    @IBAction func playDidTapped(_ sender: Any) {
        if self.playerView.isPlaying {
            self.playerView.pause()
            self.updatePlayButton(isPlaying: false)
        } else {
            self.playerView.play()
            self.updatePlayButton(isPlaying: true)
        }
    }
    
    @IBAction func fastForwardDidTapped(_ sender: Any) {
        self.playerView.forward()
    }
    
    @IBAction func moreDidTapped(_ sender: Any) {
        let moreVC = MoreViewController()
        self.present(moreVC, animated: true)
    }
    
    @IBAction func expandDidTapped(_ sender: Any) {
        self.rotateScene(landscape: true)
    }
    
    @IBAction func shrinkDidTapped(_ sender: Any) {
        self.rotateScene(landscape: false)
    }
    
    private func updatePlayButton(isPlaying: Bool) {
        let playImage = isPlaying ?
        UIImage(resource: .smallPause) :
        UIImage(resource: .smallPlay)
        
        self.playButton.setImage(playImage, for: .normal)
        self.minimizePlayButton.setImage(playImage, for: .normal)
        
        let landscapePlayImage = isPlaying ?
        UIImage(resource: .bigPause) :
        UIImage(resource: .bigPlay)
        
        self.landscapePlayButton.setImage(landscapePlayImage, for: .normal)
    }
    
    private func rotateScene(landscape: Bool) {
        if #available(iOS 16.0, *) {
            self.view.window?.windowScene?.requestGeometryUpdate(
                .iOS(interfaceOrientations: landscape ? .landscapeRight : .portrait)
            )
        } else {
            let orientation: UIInterfaceOrientation = landscape ? .landscapeRight : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
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

extension VideoViewController: PlayerViewDelegate {
    func playerViewReadyToPlay(_ playerView: PlayerView) {
        self.seekbar.setTotalPlayTime(self.playerView.totalPlayTime)
        self.updatePlayButton(isPlaying: playerView.isPlaying)
        self.updatePlayTime(0, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerView(_ playerView: PlayerView, didPlay playTime: Double, playableTime: Double) {
        self.seekbar.setPlayTime(playTime, playableTime: playableTime)
        self.updatePlayTime(playTime, totalPlayTime: playerView.totalPlayTime)
    }
    
    func playerViewDidFinishToPlay(_ playerView: PlayerView) {
        self.playerView.seek(to: 0)
        self.updatePlayButton(isPlaying: false)
    }
    
    private func updatePlayTime(_ playTime: Double, totalPlayTime: Double) {
        guard let playTimeText = DateComponentsFormatter.timeFormatter.string(from: playTime),
              let totalPlayTimeText = DateComponentsFormatter.timeFormatter.string(from: totalPlayTime)
        else {
            self.landscapePlayTimeLabel.text = nil
            return
        }
        
        self.landscapePlayTimeLabel.text = "\(playTimeText) / \(totalPlayTimeText)"
    }
}

extension VideoViewController: SeekBarViewDelegate {
    func seekbar(_ seekbar: SeekBarView, seekToPercent percent: Double) {
        self.playerView.seek(to: percent)
    }
}

extension VideoViewController: ChattingViewDelegate {
    func liveChattingViewCloseDidTapped(_ chattingView: ChattingView) {
        self.chattingView.isHidden = true
    }
}

extension VideoViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
}

extension VideoViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isBeingPresented {
            guard let view = transitionContext.view(forKey: .to) else { return }
            
            transitionContext.containerView.addSubview(view)
            
            if self.isMinimizeMode {
                self.playerViewBottomConstraint.constant = 0
                self.playerViewBottomConstraint.isActive = false
                self.playerView.isHidden = false
                self.minimizeViewBottomConstraint.isActive = false
                self.isMinimizeMode = false
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.frame = .init(
                        origin: .init(x: 0, y: view.safeAreaInsets.top),
                        size: view.window?.frame.size ?? view.frame.size
                    )
                } completion: { _ in
                    view.frame.origin = .zero
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                }

            } else {
                view.alpha = 0
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.alpha = 1
                } completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
                }
            }
        } else {
            guard let view = transitionContext.view(forKey: .from) else { return }
            
            if self.isMinimizeMode,
               let yPostion = self.delegate?.videoViewController(self, yPositionForMinimizeView: self.minimizeView.frame.height) {
                self.minimizePlayerView.player = self.playerView.player
                self.isControlPannelHidden = true
                self.playerViewBottomConstraint.isActive = true
                self.playerView.isHidden = true
                
                view.frame.origin.y = view.safeAreaInsets.top
                
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.frame.origin.y = yPostion
                    view.frame.size.height = self.minimizeView.frame.height
                } completion: { _ in
                    transitionContext.completeTransition(
                        transitionContext.transitionWasCancelled == false
                    )
                    self.minimizeViewBottomConstraint.isActive = true
                    self.delegate?.videoViewControllerDidMinimize(self)
                }
                
            } else {
                UIView.animate(
                    withDuration: self.transitionDuration(using: transitionContext)
                ) {
                    view.alpha = 0
                } completion: { _ in
                    transitionContext.completeTransition(
                        transitionContext.transitionWasCancelled == false
                    )
                    view.alpha = 1
                }
            }
        }
    }
}
