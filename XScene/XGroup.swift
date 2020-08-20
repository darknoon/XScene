struct XGroup<Content: XScene> : XScene {
    internal let content: Content

    @inlinable public init(@XSceneBuilder content: () -> Content) {
        self.content = content()
    }

    var body: Content { content }
}

