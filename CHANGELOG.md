## 1.0.5
* Security and reliability hardening for SMS query handling:
	argument validation, safer error handling, query count caps/clamping, and defensive fallback for unbounded requests
* Query and parsing improvements:
	kind de-duplication, whitespace trimming, global offset/count handling, zero-count and empty-kind handling, and more robust `SmsMessage` JSON/date parsing
* Test coverage expansion:
	added security, invalid-response, and large boundary regression tests for query behavior
* Documentation and example improvements:
	README updates (privacy-safe usage, installation, permissions) and example app message body visibility toggle
* Tooling and CI updates:
	added dependency/security scan scripts and workflow, plus security hardening/release checklist documents
* Build and dependency refresh:
	upgraded Android/Gradle-related dependencies, set example Kotlin Android plugin to 2.2.20, bumped package version to 1.0.5, and refreshed lockfiles/dev dependencies

## 1.0.4
* Bump Android Gradle Plugin to 8.3.1 
* Bump minimum supported Android SDK to 19
* Update the example app

PR from https://github.com/Sahad2701
* Migrated to FlutterPlugin using onAttachedToEngine 
* Removed deprecated PluginRegistry.Registrar usage 
* Preserved existing functionality with method channels

## 1.0.3
* Added support for AGP 8.0
* Update plugin test cases

## 1.0.2
* Remove iOS platform
* Update description and fix lint errors

## 1.0.1
* Added `Null Safety` support
* Update example app

## 0.0.1
* TODO: Describe initial release.
