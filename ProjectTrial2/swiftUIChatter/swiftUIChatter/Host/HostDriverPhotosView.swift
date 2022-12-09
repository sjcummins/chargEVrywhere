//
//  HostDriverPhotosView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/5/22.
//

import SwiftUI

struct HostDriverPhotosView: View {
    @State var img_url : String
    var body: some View {
        AsyncImage(url: URL(string: img_url)){ phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                     .scaledToFit()
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                
                EmptyView()
            }
        }//AsyncImage
    }
}
//
//struct HostDriverPhotosView_Previews: PreviewProvider {
//    static var previews: some View {
//        HostDriverPhotosView(user_id: .constant(1))
//    }
//}
