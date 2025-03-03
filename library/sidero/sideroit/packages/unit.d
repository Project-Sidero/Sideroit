module sidero.sideroit.packages.unit;
import sidero.sideroit.packages.artifact;
import sidero.sideroit.packages.aspect;
import sidero.base.text;
import sidero.base.path.file;
import sidero.base.containers.map.hashmap;

struct Unit {
    package(sidero.sideroit.packages) {
        Unit* unitCleanupLL;
    }

    String_UTF8 name;
    FilePath targetPath;
    HashMap!(String_UTF8, Artifact*) artifacts;
    HashMap!(String_UTF8, Aspect*) aspects;

    export @safe nothrow @nogc:

}
