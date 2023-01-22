//
//  UpcomingMovie.swift
//  Netflix clone
//
//  Created by Varun Bagga on 27/12/22.
//  "adult": false,
//    "backdrop_path": "/7dm64SW5L5CCg47kAEAcdCGaq5i.jpg",
//    "genre_ids": [2 items],
//    "id": 676547,
//    "original_language": "en",
//    "original_title": "Prey for the Devil",
//    "overview": "In response to a global rise in demonic possessions, the Catholic Church reopens exorcism schools to train priests in the Rite of Exorcism. On this spiritual battlefield, an unlikely warrior rises: a young nun, Sister Ann. Thrust onto the spiritual frontline with fellow student Father Dante, Sister Ann finds herself in a battle for the soul of a young girl and soon realizes the Devil has her right where he wants her.",
//    "popularity": 2710.028,
//    "poster_path": "/w3s6XEDNVGq5LUlghqs6VlvsvL6.jpg",
//    "release_date": "2022-10-23",
//    "title": "Prey for the Devil",
//    "video": false,
//    "vote_average": 6.9,
//    "vote_count": 191

import Foundation
struct UpcomingMovieResponse : Codable {
    
    let results : [UpcomingMovie]

}

struct UpcomingMovie:Codable{
//
    let id :Int
    let original_title : String?
    let original_language : String?
    let poster_path : String?
    let overview : String?
    let vote_count :Int
    let vote_average : Double
    let release_date : String?
}
