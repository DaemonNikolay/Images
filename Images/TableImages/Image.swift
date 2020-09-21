//
//  Image.swift
//  Images
//
//  Created by Nikolay Eckert on 22.09.2020.
//

import UIKit

protocol Image {
	func downloadImage(withURL url: URL,
					   forCell cell: UITableViewCell)
}
