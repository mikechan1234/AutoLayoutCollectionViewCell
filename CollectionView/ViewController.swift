//
//  ViewController.swift
//  CollectionView
//
//  Created by Chan, Michael(AWF) on 04/07/2017.
//  Copyright © 2017 eBay Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let totalCells = 150

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ExpandableCollectionViewCell.self, forCellWithReuseIdentifier: "ExpandableCell")
        
        let boringLayout = BoringLayout()
        
        collectionView.collectionViewLayout = boringLayout
        
        collectionView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return totalCells
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCollectionViewCell
        
        cell.backgroundColor = UIColor(hue: CGFloat(indexPath.item) / 255, saturation: 1, brightness: 1, alpha: 1)
        
        cell.configure(from: indexPath)
        
        return cell
    }
    
}

