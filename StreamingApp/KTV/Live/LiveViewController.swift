//
//  LiveViewController.swift
//  KTV
//
//  Created by 이정동 on 12/31/23.
//

import UIKit

class LiveViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let viewModel = LiveViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.borderColor = UIColor(resource: .gray2).cgColor
        self.containerView.layer.borderWidth = 1
        
        self.setupCollectionView()
        self.bindViewModel()
        self.viewModel.request(sort: .favorite)
    }
    
    private func bindViewModel() {
        self.viewModel.dataChanged = { [weak self] items in
            self?.collectionView.reloadData()
            
            if !items.isEmpty {
                self?.collectionView.scrollToItem(
                    at: IndexPath(item: 0, section: 0),
                    at: .top,
                    animated: false
                )
            }
           
        }
    }
    
    @IBAction func sortDidTapped(_ sender: UIButton) {
        guard sender.isSelected == false else { return }
        
        self.favoriteButton.isSelected = sender == self.favoriteButton
        self.startTimeButton.isSelected = sender == self.startTimeButton
        
        if self.favoriteButton.isSelected {
            self.viewModel.request(sort: .favorite)
        } else {
            self.viewModel.request(sort: .start)
        }
        
        
    }
    
    private func setupCollectionView() {
        self.collectionView.register(
            UINib(nibName: LiveCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: LiveCell.identifier
        )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

extension LiveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveCell.identifier, for: indexPath)
        
        if
            let cell = cell as? LiveCell,
            let data = self.viewModel.items?[indexPath.item] {
            cell.setData(data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.collectionView.frame.size.width, height: LiveCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = VideoViewController()
        vc.isLiveMode = true
        self.present(vc, animated: true)
    }
}
