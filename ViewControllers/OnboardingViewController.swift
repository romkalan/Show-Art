//
//  OnboardingViewController.swift
//  Show Art
//
//  Created by Roman Lantsov on 24.08.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {

    @IBOutlet var slideCollectionView: UICollectionView!
    @IBOutlet var nextSlideButton: UIButton!
    @IBOutlet var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = OnboardingSlideDataManager.shared.getSlidesForOnboarding()
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextSlideButton.setTitle("Let's go", for: .normal)
            } else {
                nextSlideButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextSlideButton.backgroundColor = .systemPink
        overrideUserInterfaceStyle = .light
    }
    
    @IBAction func nextSlideButtonTapped(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            guard let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? UIViewController else { return }
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            
            slideCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slide", for: indexPath)
        guard let cell = cell as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        cell.onboardingTitleLabel.text = slides[indexPath.item].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.frame.width,
            height: collectionView.frame.height
        )
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
