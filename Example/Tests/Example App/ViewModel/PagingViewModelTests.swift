//
//  PagingViewModelTests.swift
//  FireCache_Tests
//
//  Created by Jitendra Gandhi on 21/11/18.
//  Copyright © 2018 itsji10dra.com. All rights reserved.
//

import XCTest
@testable import FireCache_Example

class PagingViewModelTests: XCTestCase {

    func testLoadMoreData() {
        
        typealias DisplayModel = PasteBinListVC.ListDisplayModel
        
        let pagingViewModel = PagingViewModel<Post, DisplayModel>(endPoint: .posts,
                                                                  transform: { result -> [DisplayModel] in
            return result.map { DisplayModel(name: $0.user.name,
                                             userIconURL: $0.user.profileImage.large,
                                             postImageURL: $0.images.regular,
                                             totalLikes: "\($0.likes) likes",
                                             isLikedByUser: $0.likedByUser,
                                             color: UIColor(hexString: $0.color) ) }
        })

        let expectationPage0 = self.expectation(description: "Paging Data Fetching - Page 0")

        pagingViewModel.loadMoreData { (data, error, page) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(page, 0)
            expectationPage0.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Paging Data Fetching - Page 0 - Expectations Timeout errored: \(error)")
            }
        }
        
        let expectationPage1 = self.expectation(description: "Paging Data Fetching - Page 1")
        
        pagingViewModel.loadMoreData { (data, error, page) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(page, 1)
            expectationPage1.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Paging Data Fetching - Page 1 - Expectations Timeout errored: \(error)")
            }
        }
    }
}
