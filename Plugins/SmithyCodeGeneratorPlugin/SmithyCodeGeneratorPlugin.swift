import Foundation
import PackagePlugin

@main struct SmithyCodeGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        // Configure the commands to write to a "GeneratedSources" directory.
        let genSourcesDir = context.pluginWorkDirectory.appending("Generated")

        // We only generate commands for source targets.
        guard let target = target as? SourceModuleTarget else { return [] }

        let smithyCodeGenerator = try context.tool(named: "SmithyCodeGenerator").path

        let inputFiles = target.sourceFiles.filter {
            $0.path.extension == "smithy"
        }.map { file in
            file.path
        }

        // log the input files
        print("Input files: \(inputFiles)")

        var outputFiles: [Path] = [
//            genSourcesDir.appending("build.gradle.kts"),
//            genSourcesDir.appending("gradle.properties"),
//            genSourcesDir.appending("smithy-build.json"),
//            genSourcesDir.appending("model/main.smithy"),
        ]

        return inputFiles.map { filePath in
            let sourceFile = genSourcesDir.appending(filePath.lastComponent + ".swift")
            outputFiles.append(sourceFile)
            return .buildCommand(
                displayName: "Generating code for \(filePath.lastComponent)",
                executable: smithyCodeGenerator,
                arguments: [
                    "--input-file",
                    filePath.string,
                    "--output-directory",
                    genSourcesDir,
                    "--output-file",
                    sourceFile
                ],
                inputFiles: inputFiles,
                outputFiles:  outputFiles
            )
        }
    }
}

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

