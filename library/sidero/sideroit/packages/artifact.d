module sidero.sideroit.packages.artifact;
import sidero.sideroit.packages.buildspec;
import sidero.sideroit.packages.unit;
import sidero.base.containers.map.hashmap;
import sidero.base.allocators.classes;
import sidero.base.text;

alias ArtifactRef = CRef!Artifact;

extern (C++) class Artifact : RootRefRCClass!() {
    BuildSpec buildSpec;
    HashMap!(String_UTF8, UnitWeakRef) examples;

@safe nothrow @nogc:

    this() {
    }

}

struct ArtifactDependency {
    String_UTF8 name;

@safe nothrow @nogc:

    this(scope ref ArtifactDependency other) scope @trusted {
        this.tupleof = other.tupleof;
    }

    void opAssign(ArtifactDependency other) scope {
        this.__ctor(other);
    }
}
