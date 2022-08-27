//
//  InstructionsCollectionViewCell.swift
//  LeagueMobileChallenge
//
//  Created by Daisoreanu Laurentiu on 27.08.2022.
//

import UIKit

protocol InstructionsCollectionViewCellDelegate: AnyObject {
    func userTappedReloadData()
}

class InstructionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var largeImageView: UIImageView!
    @IBOutlet private weak var bodyLabel: UILabel!
    
    unowned private var delegate: InstructionsCollectionViewCellDelegate?
    
    class var identifier: String {
        String(describing: InstructionsCollectionViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }
    
    private func resetUI() {
        largeImageView.image = nil
        bodyLabel.text = nil
        delegate = nil
    }
    
    func configure(viewModel: InstructionItemViewModel, delegate: InstructionsCollectionViewCellDelegate) {
        largeImageView.image = viewModel.image
        bodyLabel.text = viewModel.body
        self.delegate = delegate
    }
    
    @IBAction func userTappedRetry(_ sender: Any) {
        delegate?.userTappedReloadData()
    }
    
}
