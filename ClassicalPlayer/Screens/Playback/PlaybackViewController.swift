//
//  PlaybackViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import RxSwift
import RxCocoa

class PlaybackViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var composerNameLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoContainerView: UIView!
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var viewModel: PlaybackViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        videoTitleLabel.text = viewModel.videoTitle
        composerNameLabel.text = viewModel.composerName
    }
    
    private func bindViewModel() {
        viewModel.progressSubject
            .bind(to: rx.progress)
            .disposed(by: disposeBag)
        
        viewModel.videoId.subscribe(onNext: { [weak self] videoId in
            guard let strongSelf = self else { return }
            
            PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
            PlaybackHolder.shared.videoController.videoIdentifier = videoId
            PlaybackHolder.shared.videoController.present(in: strongSelf.videoContainerView)
            PlaybackHolder.shared.videoController.moviePlayer.play()
            
            strongSelf.setupUI()
        }).disposed(by: disposeBag)
    }

    //MARK: Actions

    @IBAction func previousButtonAction(_ sender: UIButton) {
        viewModel.getPreviousVideo()
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        viewModel.getNextVideo()
    }
}

extension Reactive where Base: PlaybackViewController {
    var progress: Binder<Bool> {
        return Binder(self.base) { controller, inProgress in
            if inProgress {
                controller.activityIndicator.startAnimating()
            } else {
                controller.activityIndicator.stopAnimating()
            }
        }
    }
}
