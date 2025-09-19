.PHONY: clean

debug:
	xcodebuild -scheme WKWebViewLocal -configuration Debug -derivedDataPath build -destination 'generic/platform=iOS' clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"
	mkdir payload
	cp -r build/Build/Products/Debug-iphoneos/WKWebViewLocal.app payload/WKWebViewLocal.app
	codesign --remove payload/WKWebViewLocal.app
	zip -Ar WkWebViewLocal.ipa payload

release:
	xcodebuild -scheme WKWebViewLocal -configuration Release -derivedDataPath build -destination 'generic/platform=iOS' clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"
	mkdir payload
	cp -r build/Build/Products/Release-iphoneos/WKWebViewLocal.app payload/WKWebViewLocal.app
	codesign --remove payload/WKWebViewLocal.app
	zip -Ar WKWebViewLocal.ipa payload

clean:
	rm -rf build payload WKWebViewLocal.ipa
