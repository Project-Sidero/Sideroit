module sidero.sideroit.packages.artifact;
import sidero.sideroit.packages.dependency;
import sidero.base.text;
import sidero.base.path.file;
import sidero.base.containers.map.hashmap;
import sidero.base.containers.dynamicarray;

// TODO
enum TargetType {
    Error,
}

struct Artifact {
    package(sidero.sideroit.packages) {
        Artifact* artifactCleanupLL;
    }

    ArtifactCommon common;
    TargetType targetType;
    bool isDefault;
    HashMap!(String_UTF8, ArtifactOption*) options;

    export @safe nothrow @nogc:

}

struct ArtifactOption {
    package(sidero.sideroit.packages) {
        ArtifactOption* artifactOptionCleanupLL;
    }

    ArtifactCommon common;
    DynamicArray!Dependency dependencies;

    export @safe nothrow @nogc:

}

struct ArtifactCommon {
    String_UTF8 name;
    String_UTF8 targetName;
    FilePath targetPath;

    DynamicArray!FilePath sourceFiles;
    DynamicArray!FilePath sourcePaths;
    DynamicArray!FilePath importPaths;
    DynamicArray!FilePath excludedSourceFiles;

    String_UTF8 edition;
    DynamicArray!String_UTF8 disablecg;
    DynamicArray!String_UTF8 inheritVersions;
    DynamicArray!String_UTF8 inheritDflags;
    DynamicArray!String_UTF8 inheritLflags;

    DynamicArray!String_UTF8 libs;
    DynamicArray!String_UTF8 versions;
    DynamicArray!String_UTF8 dflags;
    DynamicArray!String_UTF8 lflags;

    export @safe nothrow @nogc:

}
