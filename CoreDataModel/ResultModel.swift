//
//  ResultModel.swift
//  MoneyTapTask
//
//  Created by Prashant Pandey on 23/07/18.
//  Copyright © 2018 Prashant Pandey. All rights reserved.
//

import Foundation

struct ResultModel {
    let batchcomplete: Bool?
    let query: QueryResult?
}

extension ResultModel:  Decodable {
    private enum ResultContainer: String, CodingKey {
        case batchcomplete = "batchcomplete"
        case query = "query"
    }
    
    init(from decoder: Decoder) throws {
        do{
            let container = try decoder.container(keyedBy: ResultContainer.self)
            let batchcomplete: Bool = try container.decode(Bool.self, forKey: .batchcomplete)
            let query: QueryResult = try container.decode(QueryResult.self, forKey: .query )
            
            self.init(batchcomplete: batchcomplete, query: query)
        } catch let exception {
            self.init(batchcomplete: nil, query: nil)
            print("ResultModel \(exception.localizedDescription)")
        }
    }
}

//MARK: QueryResult
struct QueryResult {
    let pages: [Pages]?
}

extension QueryResult: Decodable {
    private enum QueryContainer: String, CodingKey {
        case pages = "pages"
    }
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: QueryContainer.self)
            let pages: [Pages] = try container.decode([Pages].self, forKey: .pages)
            self.init(pages: pages)
        } catch let exception {
            self.init(pages: nil)
            print("QueryResult \(exception.localizedDescription)")
        }
    }
}

//MARK: Pages
struct Pages {
    let pageid: Int?
    let title: String?
    let terms: Terms?
    let thumbnail: Thumbnail?
}

extension Pages: Decodable {
    private enum PagesContainer: String, CodingKey {
        case pageId = "pageid"
        case title = "title"
        case terms = "terms"
        case thumbnail = "thumbnail"
    }
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: PagesContainer.self)
            
            var title: String?
            if let text: String = try container.decodeIfPresent(String.self, forKey: .title) {
                title = text
            }
            let pageid: Int = try container.decode(Int.self, forKey: .pageId)
            
            var terms: Terms?
            if let term: Terms = try container.decodeIfPresent(Terms.self, forKey: .terms) {
                terms = term
            }
            
            var thumbnail: Thumbnail?
            if let thumb: Thumbnail = try container.decodeIfPresent(Thumbnail.self, forKey: .thumbnail) {
                thumbnail = thumb
            }
            
            self.init(pageid: pageid, title: title, terms: terms, thumbnail: thumbnail)
        } catch let exception {
            self.init(pageid: nil, title: nil, terms: nil, thumbnail: nil)
            print("Pages \(exception.localizedDescription)")
        }
    }
}

//MARK: Terms
struct Terms {
    let description: [String]?
}

extension Terms: Decodable {
    private enum TermsContainer: String, CodingKey {
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: TermsContainer.self)
            let description: [String] = try container.decode([String].self, forKey: .description)
            
            self.init(description: description)
        } catch let exception {
            self.init(description: nil)
            print("Terms \(exception.localizedDescription)")
        }
    }
}

//MAR: Thumbnail
struct Thumbnail {
    let source: String?
}

extension Thumbnail: Decodable {
    private enum ThumbnailContainer: String, CodingKey {
        case source = "source"
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: ThumbnailContainer.self)
            let source: String = try container.decode(String.self, forKey: .source)
            self.init(source: source)
        } catch let exception {
            self.init(source: nil)
            print("Thumbnail \(exception.localizedDescription)")
        }
    }
}
