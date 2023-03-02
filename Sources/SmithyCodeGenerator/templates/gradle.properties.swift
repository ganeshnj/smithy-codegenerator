struct GradleProperties {
    let smithyVersion: String
    let smithyGradleVersion: String
}


extension GradleProperties {
    /// smithyVersion=1.27.0
    /// smithyGradleVersion=0.6.0
    func toProperties() -> String {
        """
        smithyVersion=\(smithyVersion)
        smithyGradleVersion=\(smithyGradleVersion)
        """
    }
}
