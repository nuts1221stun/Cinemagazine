//
//  CNMMovieViewController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMMovieViewController: UIViewController {
    enum Section: String {
        case image
        case info
    }
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var refreshControl = UIRefreshControl()
    private var movie: CNMMovieDataModel {
        didSet {
            update(withMovie: movie)
        }
    }
    private var collectionController: CNMCollectionController?
    private var imageSection = CNMCollectionSection(identifier: Section.image.rawValue)
    private var infoSection = CNMCollectionSection(identifier: Section.info.rawValue)
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

        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.register(CNMImageCell.self,
                                forCellWithReuseIdentifier: CNMImageCell.reuseIdentifier())
        collectionView.register(CNMMovieTitleCell.self,
                                forCellWithReuseIdentifier: CNMMovieTitleCell.reuseIdentifier())
        collectionView.register(CNMLabelCell.self,
                                forCellWithReuseIdentifier: CNMLabelCell.reuseIdentifier())
        collectionView.addSubview(refreshControl)
        view.addSubview(collectionView)

        collectionController = CNMCollectionController(collectionView: collectionView)
        imageSection.insets = .zero
        imageSection.horizontalSpacing = 0
        imageSection.verticalSpacing = 0
        collectionController?.add(section: imageSection)
        infoSection.insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        infoSection.horizontalSpacing = 0
        infoSection.verticalSpacing = 0
        collectionController?.add(section: infoSection)

        refresh(isUserTriggered: false)
    }

    @objc func didPullRefreshControl() {
        refresh(isUserTriggered: true)
    }

    @objc func refresh(isUserTriggered: Bool) {
        if isUserTriggered {
            refreshControl.beginRefreshing()
        }
        fetchMovie { [weak self] in
            if isUserTriggered {
                self?.refreshControl.endRefreshing()
            }
        }
    }

    func fetchMovie(completion: @escaping () -> Void) {
        if isFetching {
            return
        }
        isFetching = true
        CNMMovieService.fetchMovie(id: movie.id) { [weak self] (movie, error) in
            guard let strongSelf = self else { return }
            strongSelf.isFetching = false
            guard let movie = movie, error == nil else {
                completion()
                return
            }
            strongSelf.movie = movie
            completion()
        }
    }

    private func update(withMovie movie: CNMMovieDataModel) {

        let imageHelper = CNMImageHelper(imageConfiguration: CNMConfigurationManager.shared.configuration?.image)
        let backdrop = CNMImageViewModel(imagePath: movie.backdropPath ?? movie.posterPath, aspectRatio: 16.0 / 9.0, imageHelper: imageHelper)
        let imageItem = CNMCollectionItem(cellType: CNMImageCell.self,
                                          data: backdrop,
                                          eventHandler: nil,
                                          numberOfItemsPerRow: 1)

        var items = [CNMCollectionItem]()
        let title = CNMTextViewModel(text: movie.title,
                                     font: UIFont.systemFont(ofSize: 24),
                                     textColor: UIColor.black,
                                     numberOfLines: 0,
                                     minNumberOfLines: 1,
                                     insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 8))
        let titleEventHandler = CNMMovieTitleEventHandler()
        let titleCellItem = CNMCollectionItem(cellType: CNMMovieTitleCell.self,
                                              data: title,
                                              eventHandler: titleEventHandler,
                                              numberOfItemsPerRow: 1)
        items.append(titleCellItem)
        var strings = [String]()
        if let popularity = CNMNumberFormatter.popularityString(fromPopularity: movie.popularity)  {
            strings.append("\(popularity)")
        }
        if let duration = CNMTimeFormatter.durationString(fromTimeInMinutes: movie.runtime) {
            strings.append(duration)
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
                insets: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
            let item = CNMCollectionItem(cellType: CNMLabelCell.self,
                                         data: data,
                                         eventHandler: nil,
                                         numberOfItemsPerRow: 1)
            items.append(item)
        }

        if let overview = movie.overview {
            let data = CNMTextViewModel(text: overview,
                font: UIFont.systemFont(ofSize: 14),
                textColor: UIColor.black,
                numberOfLines: 0,
                minNumberOfLines: 0,
                insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
            let item = CNMCollectionItem(cellType: CNMLabelCell.self,
                                         data: data,
                                         eventHandler: nil,
                                         numberOfItemsPerRow: 1)
            items.append(item)
        }

        imageSection.update(items: [imageItem])
        infoSection.update(items: items)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
