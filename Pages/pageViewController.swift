//
//  pageViewController.swift
//  socialApp1
//
//  Created by Joe Smith on 05/04/2020.
//  Copyright © 2020 Joe Smith. All rights reserved.
//

import UIKit

class pageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let p1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id1")
        let p2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id2")
        let p3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "id3")

        // etc ...

        pages.append(p1)
        pages.append(p2)
        pages.append(p3)

        // etc ...

        setViewControllers([p2], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    var currentIndex = 0

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.firstIndex(of: viewController)!

        // if you prefer to NOT scroll circularly, simply add here:
        //if cur == 0 { return nil }
        
        var prev = (cur - 1) % pages.count
        if prev < 0 {
            prev = pages.count - 1
        }
        
        currentIndex = cur
        print(cur)
        
        if let myParent = self.parent as? inAppNav {
            myParent.updatePageIndex(index: cur)
            return pages[prev]
        }
    
        return pages[cur]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.firstIndex(of: viewController)!

        // if you prefer to NOT scroll circularly, simply add here:
        //if cur == (pages.count - 1) { return nil }

        let nxt = abs((cur + 1) % pages.count)
        
        currentIndex = cur
        print(cur)
        
        if let myParent = self.parent as? inAppNav {
            myParent.updatePageIndex(index: cur)
            return pages[nxt]
        }
        
        return pages[cur]
    }

    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
    
    func setView (index: Int) {
        if index == 0 {
            self.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        }
        if index == 1 {
            self.setViewControllers([pages[1]], direction: .forward, animated: false, completion: nil)
        }
        if index == 2 {
            self.setViewControllers([pages[2]], direction: .forward, animated: false, completion: nil)
        }
        
    }
    
    //func updatePageIndex(completion: @escaping () -> Void) {
        
    //}
    
}
