//
//  UserPostCollectionViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import UIKit
import Kingfisher

class UserPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    //TODO: should be UITextView
    @IBOutlet private weak var bodyLabel: UILabel!
    
    class var identifier: String {
        String(describing: UserPostCollectionViewCell.self)
    }

    class var cellSize: CGSize {
        let height: CGFloat = 190.0
        let width: CGFloat = UIScreen.main.currentMode!.size.width
        return CGSize(width: width, height: height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetUI()
        thumbnailImageView.kf.indicatorType = .activity
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        resetUI()
    }
    
    private func resetUI() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        bodyLabel.text = nil
        thumbnailImageView.image = nil
    }
    
    func configure(viewModel: UserPostProtocol) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        bodyLabel.text = viewModel.body
        thumbnailImageView.kf.setImage(with: viewModel.imageURL)
    }

}
