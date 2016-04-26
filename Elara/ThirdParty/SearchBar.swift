//
//  SearchBar.swift
//  Elara
//
//  Created by HeHongwe on 15/12/18.
//  Copyright © 2015年 harvey. All rights reserved.
//

import UIKit

class SearchBar:UISearchBar{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.barStyle = UIBarStyle.Default
        self.searchBarStyle = UISearchBarStyle.Default
        self.translucent = true
        self.showsSearchResultsButton = false
        self.showsScopeBar = false
        self.placeholder = "search"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
