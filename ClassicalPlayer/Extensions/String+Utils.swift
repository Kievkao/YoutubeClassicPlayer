//
//  String+Utils.swift
//  ClassicalPlayer
//
//  Created by Andrii Kravchenko on 21.12.17.
//

import Foundation

extension String {
    func localized(_ key: String? = nil, _ comment: String? = nil) -> String {
        if let key = key, let comment = comment {
            return NSLocalizedString(key, comment: comment)
        }
        return NSLocalizedString(self, comment: "")
    }
}
