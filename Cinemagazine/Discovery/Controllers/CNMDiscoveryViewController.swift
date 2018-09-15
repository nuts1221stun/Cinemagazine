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

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CNMPosterCell.self,
                                forCellWithReuseIdentifier: CNMPosterCell.reuseIdentifier())
        view.addSubview(collectionView)

        collectionView.reloadData()

        fetchMovies()
    }

    func fetchMovies() {
        if isFetching || currentPage >= (totalPages ?? Int.max) {
            return
        }
        isFetching = true
        CNMDiscoveryService.fetchMovies(sortBy: .releaseDate, order: .desc, page: currentPage + 1) { [weak self] (page, error) in
            self?.isFetching = false
            guard let strongSelf = self,
                let page = page else {
                return
            }
            if strongSelf.totalPages == nil {
                strongSelf.totalPages = page.totalPages
                strongSelf.totalResults = page.totalResults
            }
            if let currentPage = page.page {
                strongSelf.currentPage = currentPage
            }

            guard let movies = page.results,
                let posters = strongSelf.posters(fromMovies: page.results) else {
                return
            }
            var indexPaths = [IndexPath]()
            let start = strongSelf.posters.count
            for (index, _) in posters.enumerated() {
                let indexPath = IndexPath(item: start + index, section: 0)
                indexPaths.append(indexPath)
            }
            strongSelf.posters.append(contentsOf: posters)
            strongSelf.movies.append(contentsOf: movies)
            strongSelf.collectionView.insertItems(at: indexPaths)
        }
    }

    func posters(fromMovies movies: [CNMMovieDataModel]?) -> [CNMPosterViewModel]? {
        guard let movies = movies else {
            return nil
        }
        var posters = [CNMPosterViewModel]()
        for movie in movies {
            let image = CNMImageViewModel(imageUrl: movie.posterPath, aspectRatio: 0.85)
            let title = CNMTextViewModel(text: movie.title,
                                         font: UIFont.systemFont(ofSize: 14),
                                         textColor: UIColor.black)
            let popularity = CNMTextViewModel(text: "\(movie.popularity ?? 0)",
                font: UIFont.systemFont(ofSize: 12),
                textColor: UIColor.black)
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
        fetchMovies()
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
