//
//  ViewController.swift
//  Images
//
//  Created by Nikolay Eckert on 20.09.2020.
//

import UIKit

class TableImages: UIViewController, UITableViewDelegate, UITableViewDataSource, Image {
	
	@IBOutlet var tableView: UITableView!
	
	let cellReuseIdentifier = "cell"
	let rowHeight: CGFloat = CGFloat(170)
	
	var imagesCache: [UIImage?] = .init(repeating: nil,
										count: 100)
	
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.register(UITableViewCell.self,
								forCellReuseIdentifier: cellReuseIdentifier)
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.separatorStyle = .none
		self.tableView.separatorInset = .zero
		
		self.tableView.register(ImageCell.self,
								forCellReuseIdentifier: self.cellReuseIdentifier)
	}
	
	
	// MARK: - TableView
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		100
	}
	
	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		self.rowHeight
	}
	
	var timer: Timer?
	func tableView(_ tableView: UITableView,
				   willDisplay cell: UITableViewCell,
				   forRowAt indexPath: IndexPath) {
		
		let index: Int = indexPath.row
		guard let image = self.imagesCache[index] else {
			if (timer?.isValid ?? false) {
				return
			}
			
			self.timer = Timer.scheduledTimer(withTimeInterval: 1,
											  repeats: true) { (timer) in
				
				guard let _ = self.imagesCache[index] else { return }
				
				tableView.beginUpdates()
				tableView.reloadRows(at: tableView.indexPathsForVisibleRows!,
									 with: .fade)
				
				tableView.endUpdates()
				
				tableView.moveRow(at: indexPath,
								  to: indexPath)
				
				timer.invalidate()
			}
			
			return
		}
		
		cell.textLabel?.text = ""
		cell.setImage(image)
	}
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell: ImageCell = self
				.tableView
				.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ImageCell else {
			
			let cell = ImageCell()
			cell.textLabel?.text = StaticContent.isEmpty

			return cell
		}
		
		cell.separatorInset = .zero
		cell.tag = indexPath.row
		cell.textLabel?.text = StaticContent.imageLoading
		
		guard let _ = self.imagesCache[indexPath.row] else {
			guard let url = URL(string: Paths.imageSize) else {
				cell.textLabel?.text = StaticContent.wrongUrl
				return cell
			}
			
			self.downloadImage(withURL: url, forCell: cell)
			return cell
		}
		
		return cell
	}
	
	
	// MARK: - ImageCell implement
	
	func downloadImage(withURL url: URL,
					   forCell cell: UITableViewCell) {
		
		API.downloadImage(url: url.absoluteString,
						  index: cell.tag+1) { (data, error) in
			
			guard let data = data, error == nil else { return }
			
			DispatchQueue.main.async() {
				self.imagesCache[cell.tag] = UIImage(data: data)
			}
		}
	}
}
