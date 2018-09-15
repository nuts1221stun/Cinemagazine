//
//  CNMMovieViewController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

struct CNMSectionItem {
    private(set) var items = [CNMCellItem]()
    var insets = UIEdgeInsets.zero
    var horizontalSpacing: CGFloat = 0
    var verticalSpacing: CGFloat = 0
    mutating func insert(items: [CNMCellItem]?) {
        guard let items = items else { return }
        self.items.append(contentsOf: items)
    }
}

struct CNMCellItem {
    private(set) var cellType: CNMBaseCell.Type
    private(set) var data: Any
    private(set) var numberOfItemsPerRow: Int = 1
}

class CNMMovieViewController: UIViewController {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var refreshControl = UIRefreshControl()
    private var movie: CNMMovieDataModel {
        didSet {
            update(withMovie: movie)
        }
    }
    private var sectionItems = [CNMSectionItem]()
    private var isFetching = false

    struct Constants {
    }

    init(movie: CNMMovieDataModel) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.movie = CNMMovieDataModel()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CNMImageCell.self,
                                forCellWithReuseIdentifier: CNMImageCell.reuseIdentifier())
        collectionView.register(CNMLabelCell.self,
                                forCellWithReuseIdentifier: CNMLabelCell.reuseIdentifier())
        collectionView.addSubview(refreshControl)
        view.addSubview(collectionView)

        refresh(isUserTriggered: false)
    }

    @objc func didPullRefreshControl() {
        refresh(isUserTriggered: true)
    }

    @objc func refresh(isUserTriggered: Bool) {
        fetchMovie()
    }

    func fetchMovie() {
        if isFetching {
            return
        }
        isFetching = true
        CNMMovieService.fetchMovie(id: movie.id) { [weak self] (movie, error) in
            guard let strongSelf = self else { return }
            strongSelf.isFetching = false
            guard let movie = movie, error == nil else {
                return
            }
            strongSelf.movie = movie
        }
    }

    private func update(withMovie movie: CNMMovieDataModel) {
        var items = [CNMCellItem]()
        let backdrop = CNMImageViewModel(imagePath: movie.backdropPath ?? movie.posterPath, aspectRatio: 16.0 / 9.0)
        let imageCellItem = CNMCellItem(cellType: CNMImageCell.self, data: backdrop, numberOfItemsPerRow: 1)
        items.append(imageCellItem)
        let title = CNMTextViewModel(text: movie.title,
                                     font: UIFont.systemFont(ofSize: 24),
                                     textColor: UIColor.black,
                                     numberOfLines: 0,
                                     minNumberOfLines: 1,
                                     insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        let titleCellItem = CNMCellItem(cellType: CNMLabelCell.self, data: title, numberOfItemsPerRow: 1)
        items.append(titleCellItem)
        var strings = [String]()
        if let popularity = movie.popularity {
            strings.append("\(popularity)")
        }
        if let duration = movie.runtime {
            strings.append("\(duration)")
        }
        if let genres = movie.genres, genres.count > 0 {
            var string = ""
            for genre in genres {
                guard let genreName = genre.name else {
                    continue
                }
                let separator = string.count > 0 ? ", " : ""
                string = "\(string)\(separator)\(genreName)"
            }
            strings.append(string)
        }
        if let languages = movie.spokenLanguages, languages.count > 0 {
            var string = ""
            for language in languages {
                guard let languageName = language.name else {
                    continue
                }
                let separator = string.count > 0 ? ", " : ""
                string = "\(string)\(separator)\(languageName)"
            }
            strings.append(string)
        }

        for string in strings {
            let data = CNMTextViewModel(text: "\(string)",
                font: UIFont.systemFont(ofSize: 14),
                textColor: UIColor.black,
                numberOfLines: 1,
                minNumberOfLines: 1,
                insets: UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
            let item = CNMCellItem(cellType: CNMLabelCell.self, data: data, numberOfItemsPerRow: 1)
            items.append(item)
        }

        if let overview = movie.overview {
            let data = CNMTextViewModel(text: overview,
                font: UIFont.systemFont(ofSize: 14),
                textColor: UIColor.black,
                numberOfLines: 0,
                minNumberOfLines: 0,
                insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
            let item = CNMCellItem(cellType: CNMLabelCell.self, data: data, numberOfItemsPerRow: 1)
            items.append(item)
        }

        let sectionItem = CNMSectionItem(items: items,
                                         insets: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0),
                                         horizontalSpacing: 0,
                                         verticalSpacing: 0)
        self.sectionItems = [sectionItem]
        collectionView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension CNMMovieViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionItems.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section < sectionItems.count else { return 0 }
        return sectionItems[section].items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard indexPath.section < sectionItems.count,
            indexPath.item < sectionItems[indexPath.section].items.count else {
            return UICollectionViewCell()
        }
        let cellItem = sectionItems[indexPath.section].items[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellItem.cellType.reuseIdentifier(),
                                                      for: indexPath)
        if let baseCell = cell as? CNMBaseCell {
            baseCell.populate(withData: cellItem.data)
        }
        return cell
    }
}

extension CNMMovieViewController: UICollectionViewDelegate {
}

extension CNMMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard section < sectionItems.count else { return 0 }
        return sectionItems[section].horizontalSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard section < sectionItems.count else { return 0 }
        return sectionItems[section].verticalSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard section < sectionItems.count else { return .zero }
        return sectionItems[section].insets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section < sectionItems.count,
            indexPath.item < sectionItems[indexPath.section].items.count else {
                return .zero
        }
        let sectionItem = sectionItems[indexPath.section]
        let cellItem = sectionItem.items[indexPath.item]

        var width = collectionView.bounds.width
        let sectionInsets = sectionItem.insets
        width -= (sectionItem.horizontalSpacing + sectionInsets.left + sectionInsets.right)
        width -= (collectionView.contentInset.left + collectionView.contentInset.right)
        width /= CGFloat(cellItem.numberOfItemsPerRow)
        var size = CGSize(width: width, height: 0)
        size = cellItem.cellType.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                               data: cellItem.data)
        return size
    }
}

