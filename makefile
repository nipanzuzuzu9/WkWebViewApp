.PHONY: clean

debug:
	xcodebuild -scheme WebViewTemplate -configuration Debug -derivedDataPath build -destination 'generic/platform=iOS' clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"
	mkdir payload
	cp -r build/Build/Products/Debug-iphoneos/WebViewTemplate.app payload/WebViewTemplate.app
	codesign --remove payload/WebViewTemplate.app
	zip -Ar WebViewTemplate.ipa payload

release:
	xcodebuild -scheme WebViewTemplate -configuration Release -derivedDataPath build -destination 'generic/platform=iOS' clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"
	mkdir payload
	cp -r build/Build/Products/Release-iphoneos/WebViewTemplate.app payload/WebViewTemplate.app
	codesign --remove payload/WKWebViewLocal.app
	zip -Ar WebViewTemplate.ipa payload

clean:
	rm -rf build payload WebViewTemplate.ipa
