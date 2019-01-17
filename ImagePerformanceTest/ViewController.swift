//
//  ViewController.swift
//  ImagePerformanceTest
//
//  Created by CHANHEE KIM on 1/16/19.
//  Copyright © 2019 chk. All rights reserved.
//

import UIKit

enum ImageLocation {
    case folder
    case asset
}

enum ImageMethod {
    case named
    case compatibleWith
}

enum ImageCache {
    case use
    case nonuse
}

enum TestCase {
    case one   // [First Load Speed] Folder vs Asset on UIImage(named:)
    case two   // [First Load Speed] Folder vs Asset on UIImage(named:in:compatibleWith:)
    case three // Folder on UIImage(named:) vs Asset on UIImage(named:in:compatibleWith:)
    case four  // [Cache Load Speed] Folder vs Asset on UIImage(named:)
    case five  // [Cache Load Speed] Folder vs Asset on UIImage(named:in:compatibleWith:)
    //    case six   // [First Load Speed] Folder vs Asset on UIImage(named:) on Heavy Weight Project
    //    case seven // [First Load Speed] Folder vs Asset on UIImage(named:in:compatibleWith:) on Heavy Weight Project
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.startTest()
        }
    }
    
    func startTest() {
        let testCase: TestCase = .two
        
        switch testCase {
        case .one:
            test(location: .folder, method: .named)
            test(location: .asset , method: .named)
        case .two:
            //            test(location: .folder, method: .compatibleWith)
            test(location: .asset , method: .compatibleWith)
        case .three:
            test(location: .folder, method: .named)
            test(location: .asset , method: .compatibleWith)
        case .four:
            test(location: .folder, method: .named, cache: .use)
            test(location: .asset, method: .named, cache: .use)
        case .five:
            test(location: .folder, method: .compatibleWith, cache: .use)
            test(location: .asset, method: .compatibleWith, cache: .use)
        }
    }
    
    func test(location: ImageLocation, method: ImageMethod, cache: ImageCache = .nonuse) {
        var array = [UIImage]()
        
        if cache == .use {
            let name = imageName(location: location, index: 1)
            array.append(image(name: name, method: method)!)
        }
        
        let start = Date()
        _ = (1...10).forEach {
            let name = imageName(location: location, index: (cache == .use ? 1 : $0))
            array.append(image(name: name, method: method)!)
        }
        
        let totalDuration = String(format: "%.10f", Date().timeIntervalSince(start))
        print("image in <", location, "> with <", method, "> total duration : ", totalDuration + "\n")
    }
    
    func image(name: String, method: ImageMethod) -> UIImage? {
        switch method {
        case .named:
            return UIImage(named: name)
        case .compatibleWith:
            return UIImage(named: name, in: nil, compatibleWith: nil)
        }
    }
    
    func imageName(location: ImageLocation, index: Int) -> String {
        return "image" + (location == .asset ? "_asset" : "") + "\(index)"
    }
}

