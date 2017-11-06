//
//  ViewController.swift
//  Ghost
//
//  Created by Dan on 11/5/17.
//  Copyright © 2017 dc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func loadView() {
    view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if let collectionView = view as? UICollectionView {
      collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "C")
      collectionView.dataSource = self
      collectionView.delegate = self
    }

    view.backgroundColor = .black

    let tap = UITapGestureRecognizer(target: self, action: #selector(changeColour))
    tap.delegate = self
    view.addGestureRecognizer(tap)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }


  private var cellColour = UIColor.darkGray.withAlphaComponent(0.25)

  @objc private func changeColour() {
    guard let collectionView = view as? UICollectionView else { return }

    var list: [UIColor] = [
      .red,
      .blue,
      .green,
      UIColor.darkGray.withAlphaComponent(0.25)
    ]

    let index: Int = .random(range: 0...list.count)
    if list[index] == cellColour {
      changeColour()
      return
    }

    cellColour = list[index]

    for cell in collectionView.visibleCells {
      cell.backgroundColor = cellColour
    }
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int
  {
    return 5000
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "C", for: indexPath)
    cell.backgroundColor = cellColour
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    let size = max(Int(arc4random_uniform(100)), 50)
    return CGSize(width: size, height: size)
  }
}

extension ViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
  {
    return true
  }
}

extension Int {
  static func random(range: CountableClosedRange<Int> ) -> Int {
    var offset = 0

    if range.lowerBound < 0 {
      offset = abs(range.lowerBound)
    }

    let min = UInt32(range.lowerBound + offset)
    let max = UInt32(range.upperBound + offset)

    return Int(min + arc4random_uniform(max - min)) - offset
  }
}
