import Foundation
import Logging

struct Staging {
    let fromDirectory: String
    let toFile: String

    let fileManager = FileManager.default

    let logger = Logging.Logger(label: "Staging")


    func stage() throws {
        logger.info("Staging from \(fromDirectory) to \(toFile)")
        let subpaths = fileManager.subpaths(atPath: fromDirectory)

        var mergedContent = ""
        var imports: Set<String> = Set()

        for subpath in subpaths ?? [] {
            // check if it is swift file
            guard subpath.hasSuffix(".swift") else {
                logger.info("Skipping \(subpath)")
                continue
            }

            // check it is not Package.swift
            guard subpath != "Package.swift" else {
                logger.info("Skipping \(subpath)")
                continue
            }

            logger.info("Staging \(subpath)")

            // get the content of the file
            let fileURL = URL(fileURLWithPath: fromDirectory).appendingPathComponent(subpath)
            let fileContent = try String(contentsOf: fileURL)
            let fileLines = fileContent.components(separatedBy: .newlines)

            for line in fileLines {
                // check if it is an import statement
                // eg. import ClientRuntime


                if line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("import") {
                    imports.insert(line)
                } else if line.trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix("//") {
                    continue
                } else {
                    mergedContent.append("\(line)\n")
                }
            }
        }

        // write the merged content to the output file
        let importContent = imports.sorted().joined(separator: "\n")
        let finalContent = importContent + mergedContent
        let _ = try finalContent.writeIfChanged(toFile: toFile)
    }
}
