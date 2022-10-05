////
////  ConfigListView.swift
////  CanaryiOS
////
////  Created by Robert on 9/22/22.
////following tutorial found here https://developer.apple.com/tutorials/app-dev-training/displaying-cell-info
////uses a lot of words like extract and such, that kind of imply cut and paste, from the class ConfigListViewController, but that could be wrong
////might need both.
////
//
//import Foundation
//import UIKit
//
//class ConfigListViewController: UICollectionViewController{
//    var dataSource: DataSource!
//    
//    override func viewDidLoad() {
//        super .viewDidLoad()
//        
//        let listLayout = listLayout()
//        collectionView.collectionViewLayout = listLayout
//        
//        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
//
//        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
//            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//        }
//    }
//    
//    var snapshot = Snapshot()
//    snapshot.appendSections([0])
//    snapshot.appendItems(Reminder.sampleData.map { $0.title })
//    dataSource.apply(snapshot)
//    collectionView.dataSource = dataSource
//    
//    private func listLayout() -> UICollectionViewCompositionalLayout {
//        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
//        listConfiguration.showsSeparators = false
//        listConfiguration.backgroundColor = .clear
//        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
//    }
//}
//
//extension ConfigListViewController {
//    //find out where/what ReminderListViewController is
//    typealias DataSource = UICollectionViewDiffableDataSource<Int,String>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
//    
//    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath, id: String){
//        let configName = config.sampleData[indexPath.item]
//        var contentConfiguration = cell.defaultContentConfiguration()
//        contentConfiguration.text = config.title
//        contentConfiguration.secondaryText = "available for something"
//        cell.contentConfiguration = contentConfiguration
//        
//    }
//}
