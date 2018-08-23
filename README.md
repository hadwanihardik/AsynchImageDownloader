# AsynchImageDownloader
To download image Asynchronous. 
Add ImageDownloader.swift in your project. To use it. Add following code in UIViewController.

let imageDownloader = ImageDownloader()

Than to download image.

imageDownloader.downloadImageForPath(imgPath: URL) { (image) in imageView.Image = image }

To Use in Tableview.

imageDownloader.downloadImageForPath(imgPath: URL) { (image) in if let cell = tableView.cellForRow(at: indexPath) as? MyCell { cell.iconImage?.image = image } }
