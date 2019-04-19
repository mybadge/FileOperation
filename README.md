# HandleFileTool

A description of this package.

## Create a Package

Simply put: a package is a git repository with semantically versioned tags,
that contains Swift sources and a `Package.swift` manifest file at its root.

### Create a library package

A library package contains code which other packages can use and depend on. To
get started, create a directory and run `swift package init` command:

    $ mkdir MyPackage
    $ cd MyPackage
    $ swift package init # or swift package init --type library
    $ swift build
    $ swift test


### generate-xcodeproj

if need generate-xcodeproj use  `swift package generate-xcodeproj` command

    swift package generate-xcodeproj
