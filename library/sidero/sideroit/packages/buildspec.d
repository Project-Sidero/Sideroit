module sidero.sideroit.packages.buildspec;
import sidero.sideroit.packages.artifact;
import sidero.base.bitmanip : BitFlags;
import sidero.base.text;
import sidero.base.containers.map.hashmap;

struct BuildSpec {
    String_UTF8 targetName;
    TargetType targetType;
    BitFlags supports;

    HashMap!(String_UTF8, ArtifactDependency) dependencies;

    enum TargetType {
        Infer,
        Executable,
        UnitTest,
        SharedLibrary,
        StaticLibrary,
        ObjectFiles,
    }

    enum Support {
        BetterC,
    }

@safe nothrow @nogc:

    this(ref BuildSpec other) {
        this.tupleof = other.tupleof;
    }
}
