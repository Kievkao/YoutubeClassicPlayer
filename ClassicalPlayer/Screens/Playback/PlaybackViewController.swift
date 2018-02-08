//
//  PlaybackViewController.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/8/16.
//  Copyright © 2016 Kievkao. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import RxFlow
import RxSwift
import RxCocoa

final class PlaybackViewController: UIViewController {
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

        bindViewModel()
    }

    private func setupUI() {
        composerNameLabel.text = viewModel.composerName
    }
    
    private func bindViewModel() {
        viewModel.progressSubject
            .bind(to: rx.progress)
            .disposed(by: disposeBag)
        
        viewModel.video.subscribe(onNext: { [weak self] video in
            guard let strongSelf = self else { return }
            
            strongSelf.videoTitleLabel.text = video.title
            
            PlaybackHolder.shared.videoController = XCDYouTubeVideoPlayerViewController()
            PlaybackHolder.shared.videoController.videoIdentifier = video.videoId
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

extension PlaybackViewController: StoryboardBased {
    static func instantiate() -> PlaybackViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlaybackViewController") as! PlaybackViewController
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
