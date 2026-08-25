import Testing

@testable import OneImageCore

@Test func assetBundleDefaultsToMain() {
    let source = ImageReference.LocalSource.asset("logo")
    #expect(source == .asset("logo", bundle: .main))
}

@Test func remoteSourcesAreEqual() {
    let a = ImageReference.remote(.urlString("https://example.com/1.png"))
    let b = ImageReference.remote(.urlString("https://example.com/1.png"))
    #expect(a == b)
}
