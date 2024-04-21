flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf ios/Flutter/Flutter.podspec
pod update
flutter clean
