//
//  APICaller.swift
//  Netflix clone
//
//  Created by Varun Bagga on 27/12/22.
//

import Foundation


struct Constants{
    static let API_Key = "eb3482a19794cd06f4e9d543d315b447"
    static let baseURL = "https://api.themoviedb.org"
    static let youTube_API_KEY = "AIzaSyBbFfYbx27Tjie67H0-rkNzT02S9OYwreU"
    static let YoutubeBAseURl = "https://youtube.googleapis.com/youtube/v3/search?"
}

class APICaller{
    static let shared = APICaller()
    
    enum APIError: Error{
        case failedTogetData
    }
    
    func getTrendingMovies(Completion:@escaping (Result<[Title],Error>) -> Void ){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_Key)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else{
                return
            }
            
            do{// calling decodes for TrendingMoviesResponse
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(result.results))
            }catch{
                Completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTrendingTvs(Completion:@escaping (Result<[Title],Error>) -> Void ){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_Key)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else{
                return
            }
            
            do{// calling decodes for TrendingMoviesResponse
                let result = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(result.results))
                
                
            }catch{
                Completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
        
    }
    
    func getUpcomingMovies(Completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_Key)&language=en-US&page=1")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, _, error in
            guard let data = Data , error==nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(results.results))
            }catch{
                Completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    func getPopularMovies(Completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_Key)&language=en-US&page=1")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, _, error in
            guard let data = Data , error==nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(results.results))
            }catch{
                Completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    func getTopRatedMovies(Completion:@escaping (Result<[Title],Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_Key)&language=en-US&page=1")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, _, error in
            guard let data = Data , error==nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(results.results))
            }catch{
                Completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovies(Completion:@escaping (Result<[Title],Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_Key)&language=en-US&sort_by=popularity.desc&include_video=false&page=1&with_watch_monetization_types=flatrate")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, _, error in
            guard let data = Data , error==nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(results.results))
//                print(results)
            }catch{
                Completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func search(with query:String,Completion:@escaping (Result<[Title],Error>) -> Void){
        
        print("called api")
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{
            return
        }
        
        print("\(query) API ")
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_Key)&query=\(query)")else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, _, error in
            guard let data = Data , error==nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                Completion(.success(results.results))
//                print(results)
            }catch{
                Completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query:String,Completion:@escaping (Result<VideoElement,Error>) -> Void){
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)else{
            return
        }
        
        guard let url = URL(string: "\(Constants.YoutubeBAseURl)q=\(query)&key=\(Constants.youTube_API_KEY)") else{
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { Data, _, error in
            guard let data = Data , error==nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                Completion(.success(results.items[0]))
            }catch{
                Completion(.failure(error))
            }
          
        }
        task.resume()
    }
    
}
//https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher
