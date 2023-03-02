import ArgumentParser
import Foundation
import Logging
import Commands

public struct SmithyCodegen {
    let command: SmithyCodegenCommand
    let logger: Logging.Logger

    init(command: SmithyCodegenCommand) {
        self.command = command
        self.logger = Logging.Logger(label: "SmithyCodegen")
    }

    func generate() throws {
        logger.info("Generating code for \(command.inputFile)")
        let project = GradleProject(
            inputFile: command.inputFile,
            outputDirectory: command.outputDirectory,
            properties: GradleProperties(
                smithyVersion: "1.27.0",
                smithyGradleVersion: "0.6.0"
            ),
            buildGradleKts: BuildGradleKts(
                displayName: "Smithy :: Swift :: Codegen :: Test",
                moduleName: "software.amazon.smithy.swift.codegen.test",
                smithyPluginVersion: "0.5.1",
                smithyVersion: "1.27.0",
                smithySwiftCodegenVersion: "0.1.0"
            ),
            smithyBuildJson: SmithyBuildJson(
                version: "",
                plugins: ["swift-codegen" : .init(service: "example.weather#Weather",
                                                  module: "weather",
                                                  moduleVersion: "0.0.1",
                                                  build: Build(
                                                    rootProject: true
                                                  ),
                                                  gitRepo: "https://github.com/aws-amplify/smithy-swift.git",
                                                  author: "Amazon Web Services",
                                                  homepage: "https://docs.amplify.aws/",
                                                  swiftVersion: "5.5.0")]
            ),
            fileManager: FileManager.default
        )

        try project.generate()

        logger.info("Running gradle build at \(command.outputDirectory)")
        let buildResult = Commands.Bash.run("cd \(command.outputDirectory) && gradle build --stacktrace")
        guard buildResult.isSuccess else {
            logger.error("Build failed")
            logger.error(.init(stringLiteral: buildResult.errorOutput))
            return
        }
        logger.info("Build succeeded")
        logger.info(.init(stringLiteral: buildResult.output))
    }
}
