////
////  adMobview.swift
////  arambyeol2023ver
////
////  Created by 김가은 on 2023/03/20.
////
//
//import SwiftUI
//
////import SwiftUI
//import GoogleMobileAds
////struct GoogleAdView: UIViewControllerRepresentable {
////  func makeUIViewController(context: Context) -> UIViewController {
////      let viewController = UIViewController()
////        let bannerSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
////        let banner = GADBannerView(adSize: bannerSize)
////        banner.rootViewController = viewController
////        viewController.view.addSubview(banner)
////        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
////        banner.adUnitID = "ca-app-pub-2736900311526941~5872438859"
////        banner.load(GADRequest())
////        return viewController
////  }
////
////  func updateUIViewController(_ viewController: UIViewController, context: Context) {
////
////  }
////}
////struct adMobview: View {
////    
////    var body: some View {
////        VStack{
////            Spacer()
//////            GoogleAdView()
////        }
////    }
////}
////
////struct adMobview_Previews: PreviewProvider {
////    static var previews: some View {
////        adMobview()
////    }
////}
//struct GADBanner: UIViewControllerRepresentable {
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = GADBannerView(adSize: GADAdSizeBanner)
//        let viewController = UIViewController()
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
//        view.rootViewController = viewController
//        viewController.view.addSubview(view)
//        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
//        view.load(GADRequest())
//        return viewController
//    }
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//    
//    }
//}
//@ViewBuilder func admob() -> some View {
//    // admob
//    GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
//}
//
//struct adMobview: View {
//
//    var body: some View {
//        VStack{
//            Spacer()
//            admob()
//        }
//    }
//}
//
//struct adMobview_Previews: PreviewProvider {
//    static var previews: some View {
//        adMobview()
//    }
//}
