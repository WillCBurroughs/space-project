//
//  Untitled.swift
//  Space_Project iOS
//
//  Created by William Burroughs on 11/14/24.
//

import GoogleMobileAds

class RewardedViewModel: NSObject, ObservableObject, GADFullScreenContentDelegate {
    @Published var coins = 0
    var rewardedAd: GADRewardedAd?

    func loadAd() async {
        do {
            rewardedAd = try await GADRewardedAd.load(
                withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest())
            rewardedAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load rewarded ad: \(error.localizedDescription)")
        }
    }

    func showAd(from viewController: UIViewController) {
        guard let rewardedAd = rewardedAd else {
            print("Ad wasn't ready.")
            return
        }

        rewardedAd.present(fromRootViewController: viewController) {
            let reward = rewardedAd.adReward
            print("Reward amount: \(reward.amount)")
            self.addCoins(reward.amount.intValue)
        }
    }

    func addCoins(_ amount: Int) {
        coins += amount
    }

    // MARK: - GADFullScreenContentDelegate
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("Ad impression recorded.")
    }

    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("Ad clicked.")
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present full screen content: \(error.localizedDescription)")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will dismiss.")
        rewardedAd = nil // Clear the old ad

        // Reload the ad
        Task {
            await loadAd()
        }
    }
}
