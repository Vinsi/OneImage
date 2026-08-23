import SwiftUI
import Testing

@testable import View

@MainActor
struct ImageViewRenderingTests {

    @Test func localSystemImageRenders() {
        let view = ImageView(.local(.system("star")))
        let renderer = ImageRenderer(content: view)

        #expect(renderer.cgImage != nil)
    }

    @Test func resizableRendersAtProposedSize() {
        let view = ImageView(.local(.system("star"))).resizable()
        let renderer = ImageRenderer(content: view)
        renderer.proposedSize = .init(width: 100, height: 100)

        let image = renderer.cgImage
        #expect(image != nil)
        #expect(image?.width == 100)
        #expect(image?.height == 100)
    }

    @Test func invalidRemoteURLFallsBackToFailurePlaceholder() {
        let view = ImageView(.remote(.urlString("")))
            .placeholderFailure { Text("Failed") }
        let renderer = ImageRenderer(content: view)

        #expect(renderer.cgImage != nil)
    }

    @Test func resizableModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).resizable()

        #expect(view.configuration.resizeConfiguration != nil)
    }

    @Test func renderingModeModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).renderingMode(.template)

        #expect(view.configuration.renderingMode == .template)
    }

    @Test func interpolationModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).interpolation(.none)

        #expect(view.configuration.interpolation == .some(.none))
    }

    @Test func antialiasedModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).antialiased(false)

        #expect(view.configuration.isAntialiased == false)
    }

    @Test func setCornerRadiusModifierSetsConfiguration() {
        let view = ImageView(.local(.system("star"))).setCornerRadius(8)

        #expect(view.configuration.cornerRadius == 8)
    }
}
