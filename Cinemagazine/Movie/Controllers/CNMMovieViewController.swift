//
//  CNMMovieViewController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/15.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import LayoutKit

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
    private var bookEventHandler: CNMButtonEventHandlerProtocol?

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
        collectionView.addSubview(refreshControl)
        view.addSubview(collectionView)

        collectionController = CNMCollectionController(collectionView: collectionView)
        imageSection.insets = .zero
        imageSection.horizontalSpacing = 0
        imageSection.verticalSpacing = 0
        collectionController?.add(section: imageSection)
        infoSection.insets = UIEdgeInsets(top: 16, left: 16, bottom: 24, right: 16)
        infoSection.horizontalSpacing = 0
        infoSection.verticalSpacing = 0
        collectionController?.add(section: infoSection)

        refresh(isUserTriggered: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = movie.title
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
        let imageLayout = CNMAspectRatioLayout<CNMImageView>(image: backdrop,
                                                             alignment: Alignment.topFill)
        let imageItem = CNMCollectionItem(layout: imageLayout,
                                          numberOfItemsPerRow: 1)

        var items = [CNMCollectionItem]()
        let title = CNMTextViewModel(text: movie.title,
                                     font: UIFont.systemFont(ofSize: 24),
                                     textColor: UIColor.black,
                                     numberOfLines: 0)
        let titleLayout = LabelLayout<UILabel>(text: title,
                                               alignment: Alignment.topFill)
        let titleInsetLayout = InsetLayout<UIView>(insets: UIEdgeInsets(top: 4, left: 0, bottom: 16, right: 0),
                                                   alignment: Alignment.topLeading,
                                                   sublayout: titleLayout)
        let bookEventHandler = CNMMovieBookEventHandler()
        let bookButtonConfig = { (button: UIButton) in
            button.backgroundColor = UIColor.blue
            button.tintColor = UIColor.white
            button.addTarget(bookEventHandler,
                             action: #selector(bookEventHandler.didTapButton),
                             for: .touchUpInside)
        }
        let bookButtonLayout = ButtonLayout<UIButton>(type: .system,
                                                      title: "Book Now".cnm_localized(),
                                                      font: UIFont.systemFont(ofSize: 18),
                                                      contentEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
                                                      alignment: Alignment.topTrailing,
                                                      flexibility: Flexibility.low,
                                                      config: bookButtonConfig)
        let titleStackLayout = StackLayout<UIView>(axis: .horizontal,
                                                   spacing: 8,
                                                   distribution: .fillFlexing,
                                                   alignment: Alignment.topFill,
                                                   sublayouts: [titleInsetLayout, bookButtonLayout])

        let titleCellItem = CNMCollectionItem(layout: titleStackLayout,
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
                numberOfLines: 1)
            let labelLayout = LabelLayout<UILabel>(text: data,
                                                   alignment: Alignment.topFill)
            let insetLayout = InsetLayout(insets: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0),
                                          alignment: Alignment.topFill,
                                          sublayout: labelLayout)

            let item = CNMCollectionItem(layout: insetLayout,
                                         numberOfItemsPerRow: 1)
            items.append(item)
        }

        if let overview = movie.overview {
            let data = CNMTextViewModel(text: overview,
                font: UIFont.systemFont(ofSize: 14),
                textColor: UIColor.black,
                numberOfLines: 0)
            let labelLayout = LabelLayout<UILabel>(text: data,
                                                   alignment: Alignment.topFill)
            let insetLayout = InsetLayout(insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0),
                                          alignment: Alignment.topFill,
                                          sublayout: labelLayout)
            let item = CNMCollectionItem(layout: insetLayout,
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
