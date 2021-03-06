//
//  CNMDiscoveryViewController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/13.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit
import LayoutKit

class CNMDiscoveryPosterEventHandler: CNMPosterEventHandlerProtocol {
    private var movie: CNMMovieDataModel
    init(movie: CNMMovieDataModel) {
        self.movie = movie
    }
    @objc func didTapPoster() {
        CNMNavigationManager.showMovie(movie)
    }
}

class CNMDiscoveryViewController: UIViewController, CNMRootViewControllerProtocol {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CNMCollectionViewFlowLayout())
    private var refreshControl = UIRefreshControl()
    private var currentPage: Int = 0
    private var totalPages: Int?
    private var totalResults: Int = 0
    private var lastStartDate: Date?
    private var lastEndDate: Date?
    private var isFetching = false

    private var collectionController: CNMCollectionController?
    private var movieSection = CNMCollectionSection(identifier: "\(String(describing: self))-Movie")

    struct Constants {
        static let minNumberOfMovies = 40
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 32
        static let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let loadMoreScrollThreshold: CGFloat = 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setUpCollectionView()
        setUpCollectionController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        title = "Discovery".cnm_localized()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }

    private func setUpCollectionView() {
        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)

        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.addSubview(refreshControl)
        view.addSubview(collectionView)
    }

    private func setUpCollectionController() {
        collectionController = CNMCollectionController(collectionView: collectionView)
        let plugin = CNMCollectionPlugin(identifier: String(describing: self))
        plugin.scrollViewDidScroll = { [weak self] (_ scrollView: UIScrollView) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.loadMoreIfNeeded()
        }
        collectionController?.add(plugin: plugin)
        movieSection.insets = Constants.sectionInsets
        movieSection.horizontalSpacing = Constants.horizontalSpacing
        movieSection.verticalSpacing = Constants.verticalSpacing
        collectionController?.add(section: movieSection)
    }

    func startLoading() {
        refresh(isUserTriggered: false)
    }

    @objc func didPullRefreshControl() {
        refresh(isUserTriggered: true)
    }

    @objc func refresh(isUserTriggered: Bool) {
        if isUserTriggered {
            self.refreshControl.beginRefreshing()
        }
        self.currentPage = 0
        self.totalResults = 0
        let week: TimeInterval = 60 * 60 * 24 * 7
        let endDate = Date().addingTimeInterval(week)
        self.lastStartDate = endDate.addingTimeInterval(-week * 2)
        self.lastEndDate = endDate
        fetchMovies { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            if isUserTriggered {
                strongSelf.refreshControl.endRefreshing()
            }
            strongSelf.add(page: page, clearsPreviousPages: true, completion: { [weak strongSelf] in
                strongSelf?.loadMoreIfNeeded()
            })
        }
    }

    func loadMoreIfNeeded() {
        let scrollOffsetY = collectionView.contentOffset.y + collectionView.bounds.height + Constants.loadMoreScrollThreshold
        guard collectionView.contentSize.height > 0,
            scrollOffsetY >= collectionView.contentSize.height else {
            return
        }
        fetchMovies { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            strongSelf.add(page: page)
        }
    }

    func fetchMovies(
        completion: @escaping (_ page: CNMPaginationDataModel?, _ error: Error?) -> Void) {
        if isFetching {
            return
        }

        var endDate = lastEndDate
        var startDate = lastStartDate
        if currentPage >= (totalPages ?? Int.max) {
            if totalResults >= Constants.minNumberOfMovies {
                return
            }
            currentPage = 0
            if let date = lastStartDate {
                let week: TimeInterval = 60 * 60 * 24 * 7
                endDate = date.addingTimeInterval(-60 * 60 * 24)
                startDate = endDate?.addingTimeInterval(-week * 2)
                lastStartDate = startDate
                lastEndDate = endDate
            }
        }
        isFetching = true
        CNMDiscoveryService.fetchMovies(
            startDate: startDate,
            endDate: endDate,
            sortBy: .releaseDate,
            order: .desc,
            page: currentPage + 1) { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            strongSelf.isFetching = false
            completion(page, error)
        }
    }

    private func add(page: CNMPaginationDataModel?,
                     clearsPreviousPages: Bool = false,
                     completion: (() -> Void)? = nil) {
        guard let page = page else {
            completion?()
            return
        }
        if self.currentPage == 0 {
            self.totalPages = page.totalPages
            self.totalResults += (page.totalResults ?? 0)
        }
        if let currentPage = page.page {
            self.currentPage = currentPage
        }

        guard let movies = page.results,
            let cellItems = cellItems(forMovies: movies) else {
            completion?()
            return
        }
        if clearsPreviousPages {
            movieSection.update(items: cellItems, completion: completion)
        } else {
            movieSection.insert(items: cellItems, completion: completion)
        }
    }

    func cellItems(forMovies movies: [CNMMovieDataModel]?) -> [CNMCollectionItem]? {
        guard let movies = movies else {
            return nil
        }
        var cellItems = [CNMCollectionItem]()
        let imageHelper = CNMImageHelper(imageConfiguration: CNMConfigurationManager.shared.configuration?.image)
        for movie in movies {
            let image = CNMImageViewModel(imagePath: movie.posterPath ?? movie.backdropPath, aspectRatio: 0.666, imageHelper: imageHelper)
            let title = CNMTextViewModel(text: movie.title,
                                         font: UIFont.systemFont(ofSize: 14),
                                         textColor: UIColor.black,
                                         numberOfLines: 2)
            let popularityString = CNMNumberFormatter.popularityString(fromPopularity: movie.popularity) ?? ""
            let popularity = CNMTextViewModel(text: popularityString,
                                              font: UIFont.systemFont(ofSize: 12),
                                              textColor: UIColor.black,
                                              numberOfLines: 1)
            let poster = CNMPosterViewModel(image: image, title: title, popularity: popularity)
            let posterEventHandler = CNMDiscoveryPosterEventHandler(movie: movie)
            let posterLayout = CNMPosterLayout(poster: poster, eventHandler: posterEventHandler)
            let cellItem = CNMCollectionItem(layout: posterLayout,
                                             numberOfItemsPerRow: 2)
            cellItems.append(cellItem)
        }
        return cellItems
    }
}
