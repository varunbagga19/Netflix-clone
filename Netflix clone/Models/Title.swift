//
//  Movie.swift
//  Netflix clone
//
//  Created by Varun Bagga on 27/12/22.
//

import Foundation

//"adult": false,
//"backdrop_path": "/lsN1wAbqCvUPKEhkEI9pQSSiTjU.jpg",
//"id": 661374,
//"title": "Glass Onion: A Knives Out Mystery",
//"original_language": "en",
//"original_title": "Glass Onion: A Knives Out Mystery",
//"overview": "World-famous detective Benoit Blanc heads to Greece to peel back the layers of a mystery surrounding a tech billionaire and his eclectic crew of friends.",
//"poster_path": "/vDGr1YdrlfbU9wxTOdpf3zChmv9.jpg",
//"media_type": "movie",
//"genre_ids": [
//9648,
//53,
//35
//],
//"popularity": 645.243,
//"release_date": "2022-11-23",
//"video": false,
//"vote_average": 7.176,
//"vote_count": 931

struct TrendingTitleResponse : Codable {
    
    let results : [Title]

}

struct Title:Codable{
    let id :Int
    let original_title : String?
//    let media_type : String
    let original_language : String?
    let poster_path : String?
    let overview : String?
    let vote_count :Int
    let vote_average : Double
    let release_date : String?
}
