//
//  AttributedText.swift
//  Foody
//
//  Created by Shawn De Alwis on 18/9/2024.
//

import Foundation

extension String {
    // Function to remove HTML tags from a string
    func stripHTMLTags() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributedString.string
        } else {
            return self
        }
    }
}
