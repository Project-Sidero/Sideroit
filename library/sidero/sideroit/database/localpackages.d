module sidero.sideroit.database.localpackages;
import sidero.sideroit.database.peruserconfig;
import sidero.sideroit.messages;
import sidero.base.text;
import sidero.base.path.file;
import sidero.base.containers.map.hashmap;

// TODO
struct SemVer {

}

struct LocalPackages {
    private {
        bool loaded;
    }

    HashMap!(String_UTF8, LocalPackage) packages;

export @safe nothrow @nogc:

    this(return scope ref LocalPackages other) scope {
        this.tupleof = other.tupleof;
    }
}

struct LocalPackage {
    FilePath atLatest;
    HashMap!(SemVer, FilePath) atVersion;

export @safe nothrow @nogc:

    this(return scope ref LocalPackage other) scope {
        this.tupleof = other.tupleof;
    }

    void opAssign(return scope LocalPackage other) scope {
        this.__ctor(other);
    }
}

void loadLocalPackages(ref PerUserConfig perUserConfig, ref LocalPackages localPackages) {
    import sidero.eventloop.filesystem.introspection;
    import sidero.eventloop.filesystem.operations;
    import sidero.eventloop.filesystem.utils;
    import sidero.fileformats.json5;
    import sidero.base.text.processing.errors;

    if(localPackages.loaded)
        return;

    MessageBuilder messages = MessageBuilder("LOCAL PACKAGES LOADER");
    FilePath localPackagesFile = perUserConfig.perUserDir.dup;
    cast(void)(localPackagesFile ~= "local_packages.json5");

    if (!exists(localPackagesFile)) {
        write(localPackagesFile, String_UTF8(q{[
// Sideroit build manager local packages database
// https://github.com/Project-Sidero/sideroit
]})).blockUntilCompleteOrHaveValue;

        localPackages.loaded = true;
        return;
    }

    ErrorSinkRef_StringBuilder errorSink = ErrorSinkRef_StringBuilder.make;

    auto rootJson = readJSON5(localPackagesFile, cast(ErrorSinkRef)errorSink);
    rootJson.blockUntilCompleteOrHaveValue;

    if(errorSink.haveError) {
        messages.error("", errorSink.builder);
        return;
    }

    auto rootObj = rootJson.result;
    if(!rootObj) {
        // empty configuration, this is ok.

        messages.warningln("Corrupt local packages file for Sideroit at ", localPackagesFile);
        messages.warning("", errorSink.builder);
        return;
    }

    // TODO: evaluate tree
    localPackages.loaded = true;
}
