import ArgumentParser

@main
struct swift_command_shell: ParsableCommand {
    @Argument(help: "The shell command to execute")
    private var shellCommand: String

    mutating func run() throws {
        print("TODO execute \(shellCommand)")
    }
}
