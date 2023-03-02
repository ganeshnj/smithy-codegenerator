import ArgumentParser
import Foundation
import Logging
import Commands

struct Command: ParsableCommand, SmithyCodegenCommand {

    @Option(name: .long, help: "The input file to use for code generation.")
    var inputFile: String

    @Option(name: .long, help: "The output directory to use for code generation.")
    var outputDirectory: String

    @Option(name: .long, help: "The output file to use for code generation.")
    var outputFile: String

    func run() throws {
        let codegen = SmithyCodegen(command: self)
        try codegen.generate()

        // /Users/jangirg/Developer/Playground/MyApp/.build/plugins/outputs/myapp/MyApp/SmithyCodeGeneratorPlugin/Generated/build/smithyprojections/Generated/source/swift-codegen
        let generatedSource = outputDirectory.appending("/build/smithyprojections/Generated/source/swift-codegen")
        let staging = Staging(fromDirectory: generatedSource, toFile: outputFile)
        try staging.stage()
    }
}



public protocol SmithyCodegenCommand {
    var inputFile: String { get }
    var outputDirectory: String { get }
    var outputFile: String { get }
}

Command.main()
