//
//  OnboardingSlideDataManager.swift
//  Show Art
//
//  Created by Roman Lantsov on 24.08.2023.
//

import Foundation

struct OnboardingSlideDataManager {
    static let shared = OnboardingSlideDataManager()
    
    private init() {}
    
    func getSlidesForOnboarding() -> [OnboardingSlide] {
        [
            OnboardingSlide(
                title: "Show Art will allow you to realize your fantasies"
            ),
            OnboardingSlide(
                title: "It’s incredibly easy and fun!"
            ),
            OnboardingSlide(
                title: "Use color palette or create your unique color"
            ),
            OnboardingSlide(
                title: "Share the result with your friends"
            )
        ]
    }
}
