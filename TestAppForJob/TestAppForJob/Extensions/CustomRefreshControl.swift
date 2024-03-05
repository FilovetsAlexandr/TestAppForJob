//
//  CustomRefreshControl.swift
//  TestAppForJob
//
//  Created by Alexandr Filovets on 5.03.24.
//

import UIKit
import NVActivityIndicatorView

class CustomRefreshControl: UIRefreshControl {
    private var activityIndicator: NVActivityIndicatorView!

    override init() {
        super.init()

        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), type: .ballRotateChase, color: .purple, padding: 0)
        addSubview(activityIndicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    func startAnimating() {
        activityIndicator.startAnimating()
        beginRefreshing()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        endRefreshing()
    }
}
