//
//  ImageCell.swift
//  Images
//
//  Created by Nikolay Eckert on 22.09.2020.
//

import UIKit

class ImageCell: UITableViewCell {
	override func prepareForReuse() {
		self.imageView?.image = nil
	}
}
