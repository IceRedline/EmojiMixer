//
//  ViewController.swift
//  EmojiMixer
//
//  Created by Артем Табенский on 01.04.2025.
//

import UIKit

class CollectionViewController: UIViewController {

    private let emojis = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"]
    private var visibleEmojis = [String]()
    private var currentEmojiIndex: Int = 0
    
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "undo",
            style: .plain,
            target: self,
            action: #selector(undoTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        
        view.addSubview(collection)
        loadConstraints()
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func loadConstraints() {
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func add(emoji: String) {
        
        let count = visibleEmojis.count
        visibleEmojis.append(emoji)
        
        collection.performBatchUpdates {
            let indexes = (count..<visibleEmojis.count).map { IndexPath(row: $0, section: 0) }
            collection.insertItems(at: indexes)
        }
    }
    
    private func remove() {
        let count = visibleEmojis.count
        visibleEmojis.removeLast()
        
        collection.performBatchUpdates {
            let indexes = (visibleEmojis.count..<count).map { IndexPath(row: $0, section: 0) }
            collection.deleteItems(at: indexes)
        }
    }
    
    @objc private func addTapped() {
        let selectedEmoji = emojis[currentEmojiIndex]
        if currentEmojiIndex != emojis.count - 1 {
            currentEmojiIndex += 1
        }
        if visibleEmojis.last != emojis.last {
            add(emoji: selectedEmoji)
        }
    }
    
    @objc private func undoTapped() {
        if !visibleEmojis.isEmpty {
            remove()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { visibleEmojis.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.prepareForReuse()
        let label = UILabel()
        if !visibleEmojis.isEmpty {
            label.text = visibleEmojis[indexPath.item]
        }
        cell.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        return cell
    }
}

