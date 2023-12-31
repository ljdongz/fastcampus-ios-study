//
//  ChattingView.swift
//  KTV
//
//  Created by 이정동 on 12/31/23.
//

import UIKit

protocol ChattingViewDelegate: AnyObject {
    func liveChattingViewCloseDidTapped(_ chattingView: ChattingView)
}

class ChattingView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ChattingViewDelegate?
    
    private let viewModel = ChattingViewModel()
    
    override var isHidden: Bool {
        didSet {
            self.toggleViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCollectionView()
        self.setupTextField()
        self.bindViewModel()
        self.toggleViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.chatReceived = { [weak self] in
            self?.collectionView.reloadData()
            self?.scrollToLastIfNeeded()
        }
    }
    
    private func toggleViewModel() {
        if self.isHidden {
            self.viewModel.stop()
        } else {
            self.viewModel.start()
        }
    }
    
    private func scrollToLastIfNeeded() {
        let isBottomOffset = self.collectionView.bounds.maxY >= self.collectionView.contentSize.height
        let isLastMessageMine = self.viewModel.messages.last?.isMine == true
        
        if isBottomOffset || isLastMessageMine {
            self.collectionView.scrollToItem(
                at: IndexPath(item: self.viewModel.messages.count - 1, section: 0),
                at: .bottom,
                animated: false
            )
        }
    }
    
    private func setupTextField() {
        self.textField.delegate = self
        self.textField.attributedPlaceholder = NSAttributedString(
            string: "채팅에 참여하세요!",
            attributes: [
                .foregroundColor: UIColor(resource: .chatText),
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
        )
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            UINib(nibName: LiveChattingMessageCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier
        )
        self.collectionView.register(
            UINib(nibName: LiveChattingMyMessageCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier
        )
    }
    
    @IBAction func closeButtonDidTapped(_ sender: Any) {
        self.textField.resignFirstResponder()
        self.delegate?.liveChattingViewCloseDidTapped(self)
    }
}

extension ChattingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.viewModel.messages[indexPath.item]
        let width = collectionView.frame.width - 32
        
        if item.isMine {
            return LiveChattingMyMessageCollectionViewCell.size(width: width, text: item.text)
        } else {
            return LiveChattingMessageCollectionViewCell.size(width: width, text: item.text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension ChattingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.viewModel.messages[indexPath.item]
        
        if item.isMine {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveChattingMyMessageCollectionViewCell.identifier, for: indexPath)
            
            if let cell = cell as? LiveChattingMyMessageCollectionViewCell {
                cell.setText(item.text)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveChattingMessageCollectionViewCell.identifier, for: indexPath)
            
            if let cell = cell as? LiveChattingMessageCollectionViewCell {
                cell.setText(item.text)
            }
            
            return cell
        }
    }
}

extension ChattingView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return false
        }
        
        self.viewModel.sendMessage(text)
        textField.text = nil
        
        return true
    }
}
