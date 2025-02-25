module sidero.sideroit.packages.unit;
import sidero.sideroit.packages.artifact;
import sidero.sideroit.packages.buildspec;
import sidero.base.allocators.classes;
import sidero.base.containers.map.hashmap;
import sidero.base.text;

alias UnitRef = CRef!(Unit!());

extern (C++) class Unit() : RootRefRCClass!() {
    BuildSpec buildSpec;
    HashMap!(String_UTF8, ArtifactRef) artifacts;

@safe nothrow @nogc:

    this() {
    }

    int opCmp(scope Unit other) scope {
        ulong a = this.toHash, b = other.toHash;

        if(a < b)
            return -1;
        else if(a > b)
            return 1;
        else
            return 0;
    }
}

struct UnitWeakRef {
    Unit!() unit;
}
