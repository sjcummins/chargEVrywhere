//
//  StarReview.swift
//  swiftUIChatter
//
//  Created by Jacob Klionsky on 11/18/22.
//

import SwiftUI

struct StarReview: View {
    @Binding var rating: Double

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    
    
    
    func image(for number: Int) -> Image {
        if Double(number) > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    
    
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(Double(number) > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = Double(number)
                    }
            }
        }
        
    }
}

