import Foundation
import Logging
import Commands

struct GradleProject {
    let inputFile: String
    let outputDirectory: String
    let properties: GradleProperties
    let buildGradleKts: BuildGradleKts
    let smithyBuildJson: SmithyBuildJson

    let fileManager: FileManager

    let logger = Logging.Logger(label: "GradleProject")

    func generate() throws {
        logger.info("Output directory: \(outputDirectory)")

        try fileManager.createDirectory(atPath: outputDirectory, withIntermediateDirectories: true, attributes: nil)

        // copy inputFile to model dir
        try fileManager.createDirectory(atPath: outputDirectory.appending("/model"), withIntermediateDirectories: true, attributes: nil)
        let modelData = fileManager.contents(atPath: inputFile)!
        let modelString = String(data: modelData, encoding: .utf8)
        _ = try modelString?.writeIfChanged(toFile: "\(outputDirectory)/model/main.smithy")
        _ = try properties.toProperties().writeIfChanged(toFile: "\(outputDirectory)/gradle.properties")
        _ = try buildGradleKts.toKotlin().writeIfChanged(toFile: "\(outputDirectory)/build.gradle.kts")
        _ = try smithyBuildJson.toJSON().writeIfChanged(toFile: "\(outputDirectory)/smithy-build.json")
//        shell(currentDirectory: outputDirectory, "./gradlew build")
    }
}

// https://github.com/soto-project/soto-codegenerator/blob/8fad5a4e1b131d00ac1d900910bd0d7b34d8e995/Sources/SotoCodeGeneratorLib/SotoCodeGen.swift#L237
extension String {
    /// Only writes to file if the string contents are different to the file contents. This is used to stop XCode rebuilding and reindexing files unnecessarily.
    /// If the file is written to XCode assumes it has changed even when it hasn't
    /// - Parameters:
    ///   - toFile: Filename
    ///   - atomically: make file write atomic
    ///   - encoding: string encoding
    func writeIfChanged(toFile: String) throws -> Bool {
        do {
            let original = try String(contentsOfFile: toFile)
            guard original != self else { return false }
        } catch {
            // print(error)
        }
        try write(toFile: toFile, atomically: true, encoding: .utf8)
        return true
    }
}