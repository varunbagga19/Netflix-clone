//
//  YoutubeSearchResponse.swift
//  Netflix clone
//
//  Created by Varun Bagga on 29/12/22.
//

import Foundation
/* items =     (
 {
etag = "o90D6H9_bD2mS_uqoSw3UbBb3Xo";
id =             {
 kind = "youtube#video";
 videoId = gmKxSus01bQ;
};
kind = "youtube#searchResult";
},*/

struct YoutubeSearchResponse: Codable{
    
    let items:[VideoElement]
}

struct VideoElement:Codable{
    let id : IdVideoElement
}
struct IdVideoElement:Codable{
    let kind : String
    let videoId : String
}
