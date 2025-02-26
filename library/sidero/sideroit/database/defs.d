module sidero.sideroit.database.defs;
import sidero.base.path.file;
import sidero.base.text;
import sidero.base.containers.map.hashmap;
import sidero.base.containers.dynamicarray;

struct FSDatabaseLocation {
    FilePath location;
    HashMap!(String_UTF8, FSDatabaseEntry) entries;

@safe nothrow @nogc:

    this(scope ref FSDatabaseLocation other) scope @trusted {
        this.tupleof = other.tupleof;
    }
}

struct FSDatabaseEntry {
    DynamicArray!(FSDatabaseEntryVersion) versions;

@safe nothrow @nogc:

    this(scope ref FSDatabaseEntry other) scope @trusted {
        this.tupleof = other.tupleof;
    }

    void opAssign(scope ref FSDatabaseEntry other) scope {
        this.__ctor(other);
    }
}

struct FSDatabaseEntryVersion {
    Semver version_;
    FilePath location;

@safe nothrow @nogc:

    this(scope ref FSDatabaseEntryVersion other) scope @trusted {
        this.tupleof = other.tupleof;
    }

    void opAssign(scope ref FSDatabaseEntryVersion other) scope {
        this.__ctor(other);
    }
}

struct Semver {

}
