import Foundation
import ArgumentParser

@main
struct swift_command_shell: ParsableCommand {
    @Argument(help: "The shell command to execute")
    private var shellCommand: String

    mutating func run() throws {
        let output = shell(shellCommand)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let data = try jsonEncoder.encode(output)
        let shellOutputString = String(data: data, encoding: .utf8)!
        print(shellOutputString)
    }
}

struct ShellOutput: Codable {
    let command: String
    let text: String?
    let exitCode: Int32
}

@discardableResult
func shell(_ command: String, printOutput: Bool = false) -> ShellOutput {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil

    if printOutput {
        pipe.fileHandleForReading.readabilityHandler = { pipe in
            let data = pipe.availableData
            guard !data.isEmpty, let line = String(data: data, encoding: .utf8) else {
                return
            }
            print(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)

    task.waitUntilExit()

    return ShellOutput(command: command, text: output, exitCode: task.terminationStatus)
}
