//
//  DriverHostPhotosView.swift
//  swiftUIChatter
//
//  Created by Allison Kwang on 11/6/22.
//

import SwiftUI
import UIKit

struct DriverHostPhotosView: View {

    @State var urls = [PhotoURL]()
    var body: some View {
        VStack{
            
            ScrollViewReader { proxy in
                List{
                    ForEach (urls) { url in
                        
                        AsyncImage(url: URL(string: url.img_url)){ phase in
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
                
            }
        }
    }
}
//
//struct DriverHostPhotosView_Previews: PreviewProvider {
//    static var previews: some View {
//        DriverHostPhotosView()
//    }
//}
