module sidero.sideroit.packages.aspect;
import sidero.sideroit.packages.dependency;
import sidero.base.text;
import sidero.base.path.file;
import sidero.base.containers.dynamicarray;

// TODO
struct AspectBefore {

}

struct Aspect {
    package(sidero.sideroit.packages) {
        Aspect* aspectCleanupLL;
    }

    String_UTF8 name;

    DynamicArray!FilePath sourceFiles;
    DynamicArray!FilePath sourcePaths;
    DynamicArray!FilePath importPaths;
    DynamicArray!FilePath excludedSourceFiles;

    DynamicArray!Dependency dependencies;
    DynamicArray!FilePath triggeredBy;

    DynamicArray!AspectBefore before;

    export @safe nothrow @nogc:

}
