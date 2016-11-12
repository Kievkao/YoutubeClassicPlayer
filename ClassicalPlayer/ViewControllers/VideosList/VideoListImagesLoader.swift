//
//  VideoListImagesLoader.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class VideoListImagesLoader {

    private let imageCache = AutoPurgingImageCache()

    private var loadingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        queue.qualityOfService = .userInitiated
        queue.name = "Video list images loading queue"

        return queue
    }()

    private let ongoingOperations = NSMapTable<NSURL, BlockOperation> (keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)

    func loadImageFor(imageURL: URL, completion:@escaping (_ image : UIImage?) -> Void) {
        if let cachedImage = imageCache.image(withIdentifier: imageURL.absoluteString)  {
            completion(cachedImage)
            return
        }

        let loadImageOperation = BlockOperation { 
            Alamofire.request(imageURL).responseImage { response in
                if let image = response.result.value {
                    self.imageCache.add(image, withIdentifier: imageURL.absoluteString)
                }
                completion(response.result.value)
            }
        }
        ongoingOperations.setObject(loadImageOperation, forKey: NSURL(string: imageURL.absoluteString))
        loadingQueue.addOperation(loadImageOperation)
    }

    func cancelImageLoadingFor(imageURL: URL) {
        let nsURL = NSURL(string: imageURL.absoluteString)

        if let operation = ongoingOperations.object(forKey: nsURL) {
            operation.cancel()
            ongoingOperations.removeObject(forKey: nsURL)
        }
    }
}
