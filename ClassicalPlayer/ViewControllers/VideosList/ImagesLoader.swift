//
//  ImagesLoader.swift
//  ClassicalPlayer
//
//  Created by Kravchenko, Andrii on 11/12/16.
//  Copyright © 2016 kievkao. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ImagesLoader {
    private let imageCache = AutoPurgingImageCache()
    private let ongoingRequests = NSMapTable<NSURL, DataRequest> (keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)

    func loadImageFor(imageURL: URL, completion:@escaping (_ image : UIImage?) -> Void) {
        if let cachedImage = imageCache.image(withIdentifier: imageURL.absoluteString)  {
            completion(cachedImage)
            return
        }

        let request = Alamofire.request(imageURL).responseImage { response in
            if let image = response.result.value {
                self.imageCache.add(image, withIdentifier: imageURL.absoluteString)
            }
            completion(response.result.value)
        }
        ongoingRequests.setObject(request, forKey: NSURL(string: imageURL.absoluteString))
    }

    func cancelImageLoadingFor(imageURL: URL) {
        let nsURL = NSURL(string: imageURL.absoluteString)

        if let request = ongoingRequests.object(forKey: nsURL) {
            request.cancel()
            ongoingRequests.removeObject(forKey: nsURL)
        }
    }
}
