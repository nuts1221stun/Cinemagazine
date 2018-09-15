//
//  CNMDiscoveryViewController.swift
//  Cinemagazine
//
//  Created by Li-Erh Chang on 2018/9/13.
//  Copyright © 2018 nuts. All rights reserved.
//

import UIKit

class CNMDiscoveryViewController: UIViewController {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var refreshControl = UIRefreshControl()
    private var currentPage: Int = 0
    private var totalPages: Int?
    private var totalResults: Int?
    private var movies = [CNMMovieDataModel]()
    private var posters = [CNMPosterViewModel]()
    private var isFetching = false

    struct Constants {
        static let horizontalSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 16
        static let sectionInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let loadMoreScrollThreshold: CGFloat = 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        refreshControl.addTarget(self, action: #selector(didPullRefreshControl), for: .valueChanged)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CNMPosterCell.self,
                                forCellWithReuseIdentifier: CNMPosterCell.reuseIdentifier())
        collectionView.addSubview(refreshControl)
        view.addSubview(collectionView)

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
        fetchMovies { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            if isUserTriggered {
                strongSelf.refreshControl.endRefreshing()
            }
            strongSelf.add(page: page, clearsPreviousPages: true)
        }
    }

    func loadMore() {
        fetchMovies { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            strongSelf.add(page: page)
        }
    }

    func fetchMovies(completion: @escaping (_ page: CNMPaginationDataModel?, _ error: Error?) -> Void) {
        if isFetching || currentPage >= (totalPages ?? Int.max) {
            return
        }
        isFetching = true
        CNMDiscoveryService.fetchMovies(sortBy: .releaseDate, order: .desc, page: currentPage + 1) { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            strongSelf.isFetching = false
            completion(page, error)
        }
    }

    private func add(page: CNMPaginationDataModel?, clearsPreviousPages: Bool = false) {
        guard let page = page else {
            return
        }
        if self.currentPage == 0 {
            self.totalPages = page.totalPages
            self.totalResults = page.totalResults
        }
        if let currentPage = page.page {
            self.currentPage = currentPage
        }

        guard let movies = page.results,
            let posters = self.posters(fromMovies: page.results) else {
                return
        }
        var indexPaths = [IndexPath]()
        let start = self.posters.count
        for (index, _) in posters.enumerated() {
            let indexPath = IndexPath(item: start + index, section: 0)
            indexPaths.append(indexPath)
        }
        if clearsPreviousPages {
            self.movies = [CNMMovieDataModel]()
            self.posters = [CNMPosterViewModel]()
        }
        self.posters.append(contentsOf: posters)
        self.movies.append(contentsOf: movies)
        if clearsPreviousPages {
            self.collectionView.reloadData()
        } else {
            self.collectionView.insertItems(at: indexPaths)
        }
    }

    func posters(fromMovies movies: [CNMMovieDataModel]?) -> [CNMPosterViewModel]? {
        guard let movies = movies else {
            return nil
        }
        var posters = [CNMPosterViewModel]()
        for movie in movies {
            let image = CNMImageViewModel(imagePath: movie.posterPath ?? movie.backdropPath, aspectRatio: 0.666)
            let title = CNMTextViewModel(text: movie.title,
                                         font: UIFont.systemFont(ofSize: 14),
                                         textColor: UIColor.black,
                                         numberOfLines: 2,
                                         minNumberOfLines: 2,
                                         insets: .zero)
            let popularity = CNMTextViewModel(text: "\(movie.popularity ?? 0)",
                                                font: UIFont.systemFont(ofSize: 12),
                                                textColor: UIColor.black,
                                                numberOfLines: 1,
                                                minNumberOfLines: 1,
                                                insets: .zero)
            let poster = CNMPosterViewModel(image: image, title: title, popularity: popularity)
            posters.append(poster)
        }
        return posters
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension CNMDiscoveryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CNMPosterCell.reuseIdentifier(),
                                                      for: indexPath)
        if indexPath.item < posters.count,
            let posterCell = cell as? CNMPosterCell {
            posterCell.populate(withData: posters[indexPath.item])
        }
        return cell
    }
}

extension CNMDiscoveryViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffsetY = scrollView.contentOffset.y + scrollView.bounds.height + Constants.loadMoreScrollThreshold
        guard scrollOffsetY >= scrollView.contentSize.height else {
            return
        }
        loadMore()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < movies.count else {
            return
        }
        let vc = CNMMovieViewController(movie: movies[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CNMDiscoveryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.horizontalSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.verticalSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        let sectionInsets = Constants.sectionInsets
        width -= (Constants.horizontalSpacing + sectionInsets.left + sectionInsets.right)
        width -= (collectionView.contentInset.left + collectionView.contentInset.right)
        width /= 2
        var size = CGSize(width: width, height: 0)
        if indexPath.item < posters.count {
            size = CNMPosterCell.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                              data: posters[indexPath.item])
        }
        return size
    }
}
