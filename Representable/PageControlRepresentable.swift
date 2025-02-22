//
//  PageControlRepresentable.swift
//
//
//  Created by Kyoya Yamaguchi on 2024/07/24.
//

import SwiftUI

struct PageControlRepresentable: UIViewRepresentable {

    @Binding var currentPage: Int
    var numberOfPages: Int

    class Coordinator: NSObject {
        var parent: PageControlRepresentable

        init(parent: PageControlRepresentable) {
            self.parent = parent
        }

        @objc
        func pageControlValueChanged(_ sender: UIPageControl) {
            parent.currentPage = sender.currentPage
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = UIColor(white: 0.7, alpha: 1)
        pageControl.addTarget(
            context.coordinator,
            action: #selector(Coordinator.pageControlValueChanged),
            for: .valueChanged
        )
        return pageControl
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}
