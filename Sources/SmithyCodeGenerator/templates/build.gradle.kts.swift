struct BuildGradleKts {
    let displayName: String
    let moduleName: String

    let smithyPluginVersion: String
    let smithyVersion: String
    let smithySwiftCodegenVersion: String
}

extension BuildGradleKts {
    /// extra["displayName"] = "Smithy :: Swift :: Codegen :: Test"
    /// extra["moduleName"] = "software.amazon.smithy.swift.codegen.test"
    ///
    /// tasks["jar"].enabled = false
    ///
    /// plugins {
    ///     id("software.amazon.smithy").version("0.5.1")
    /// }
    ///
    /// val smithyVersion: String by project
    ///
    /// dependencies {
    ///     implementation(project(":smithy-swift-codegen"))
    ///     implementation("software.amazon.smithy:smithy-protocol-test-traits:$smithyVersion")
    ///     implementation("software.amazon.smithy:smithy-aws-traits:$smithyVersion")
    /// }
    func toKotlin() -> String {
        """
        repositories {
            mavenLocal()
            mavenCentral()
        }

        plugins {
            id("software.amazon.smithy").version("\(smithyPluginVersion)")
        }

        val smithyVersion: String by project

        dependencies {
            implementation("software.amazon.smithy:smithy-swift-codegen:\(smithySwiftCodegenVersion)")
            implementation("software.amazon.smithy:smithy-protocol-test-traits:\(smithyVersion)")
            implementation("software.amazon.smithy:smithy-aws-traits:\(smithyVersion)")
        }
        """
    }
}
