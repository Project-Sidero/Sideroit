module sidero.sideroit.database.localpackages;
import sidero.sideroit.database.peruserconfig;
import sidero.sideroit.messages;
import sidero.base.text;
import sidero.base.path.file;
import sidero.base.containers.map.hashmap;
import sidero.base.containers.list.linkedlist;

// TODO
struct SemVer {
    String_UTF8 text;

export @safe nothrow @nogc:

    this(return scope ref SemVer other) scope {
        this.tupleof = other.tupleof;
    }

    void opAssign(return scope SemVer other) scope {
        this.__ctor(other);
    }
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

    scope(exit)
        localPackages.loaded = true;

    MessageBuilder messages = MessageBuilder("LOCAL PACKAGES LOADER");

    if(perUserConfig.perUserDir.isNull) {
        messages.warningln("No user directory to look for local packages database in");
        return;
    }

    FilePath localPackagesFile = perUserConfig.perUserDir.dup;
    cast(void)(localPackagesFile ~= "local_packages.json5");

    if(!exists(localPackagesFile)) {
        write(localPackagesFile, String_UTF8(q{{
// Sideroit build manager local packages database
// https://github.com/Project-Sidero/sideroit
}})).blockUntilCompleteOrHaveValue;

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

    if(rootObj.type != JSONValue.Type.Object) {
        messages.warningln("Found JSON value type ", rootObj.type, " expected an object at root");
        return;
    }

    rootObj.match((LinkedList!JSONValue) => assert(0), (HashMap!(String_UTF8, JSONValue) map) {
        // name: {
        foreach(k, v; map) {
            assert(k);
            assert(v);

            if(v.type != JSONValue.Type.Object) {
                messages.warningln("Found JSON value type ", v.type, " expected an object for key ", k.get);
                return;
            }

            LocalPackage localPackage;
            bool doneOne;

            scope(exit) {
                if(doneOne)
                    localPackages.packages[k.get] = localPackage;
            }

            v.match((LinkedList!JSONValue) => assert(0), (HashMap!(String_UTF8, JSONValue) map) {
                if(String_UTF8("latest") in map) {
                    //      latest: "path",

                    auto latest = map[String_UTF8("latest")];
                    assert(latest);

                    if(latest.type != JSONValue.Type.String) {
                        messages.warningln("Found JSON value type ", latest.type, " expected a string for key ", k.get, " on latest");
                        return;
                    }

                    latest.match((LinkedList!JSONValue) => assert(0), (HashMap!(String_UTF8, JSONValue)) => assert(0),
                    (DynamicBigInteger) => assert(0), (bool) => assert(0), (double) => assert(0), (String_UTF8 text) {
                        auto filePath = FilePath.from(text);
                        if(!filePath) {
                            messages.warningln("Unrecognized path format found for key ", k.get, ": ", text);
                            return;
                        }

                        localPackage.atLatest = filePath;
                        doneOne = true;
                    }, () => assert(0));
                }

                if(String_UTF8("versions") in map) {
                    //      versions: [
                    auto versions = map[String_UTF8("versions")];
                    assert(versions);

                    if(versions.type != JSONValue.Type.Array) {
                        messages.warningln("Found JSON value type ", versions.type, " expected an array for key ", k.get, " for versions");
                        return;
                    }

                    versions.match((LinkedList!JSONValue list) {
                        foreach(ver; list) {
                            assert(ver);
                            //          {

                            if(ver.type != JSONValue.Type.Object) {
                                messages.warningln("Found JSON value type ", versions.type,
                                " expected an object for key ", k.get, " for versions");
                                return;
                            }

                            ver.match((LinkedList!JSONValue) => assert(0), (HashMap!(String_UTF8, JSONValue) map2) {
                                auto path = map2[String_UTF8("path")];
                                auto ver2 = map2[String_UTF8("version")];

                                if(!path || !ver2)
                                    return;

                                if(path.type != JSONValue.Type.String) {
                                    messages.warningln("Found JSON value type ", path.type,
                                    " expected a string for key ", k.get, " for a version with its path");
                                    return;
                                }

                                if(ver2.type != JSONValue.Type.String) {
                                    messages.warningln("Found JSON value type ", ver2.type,
                                    " expected a string for key ", k.get, " for a version with its version");
                                    return;
                                }

                                FilePath filePath;

                                path.match((LinkedList!JSONValue) => assert(0), (HashMap!(String_UTF8,
                                JSONValue)) => assert(0), (DynamicBigInteger) => assert(0), (bool) => assert(0),
                                (double) => assert(0), (String_UTF8 text) {
                                    //              path: "path",

                                    auto filePath2 = FilePath.from(text);
                                    if(!filePath2) {
                                        messages.warningln("Unrecognized path format found for key ", k.get,
                                        " and version ", ver2, ": ", text);
                                        return;
                                    }

                                    filePath = filePath2;
                                }, () => assert(0));

                                SemVer semVer;

                                ver2.match((LinkedList!JSONValue) => assert(0), (HashMap!(String_UTF8,
                                JSONValue)) => assert(0), (DynamicBigInteger) => assert(0), (bool) => assert(0),
                                (double) => assert(0), (String_UTF8 text) {
                                    //              version: "0.0.0"

                                    semVer = SemVer(text);
                                }, () => assert(0));

                                if(!filePath.isNull)
                                    localPackage.atVersion[semVer] = filePath;
                            }, (DynamicBigInteger) => assert(0), (bool) => assert(0), (double) => assert(0),
                            (String_UTF8) => assert(0), () => assert(0));

                            //          }
                        }
                    }, (HashMap!(String_UTF8, JSONValue)) => assert(0), (DynamicBigInteger) => assert(0),
                    (bool) => assert(0), (double) => assert(0), (String_UTF8) => assert(0), () => assert(0));

                    //      ]
                }
            }, (DynamicBigInteger) => assert(0), (bool) => assert(0), (double) => assert(0), (String_UTF8) => assert(0), () => assert(0));
        }
        // }
    }, (DynamicBigInteger) => assert(0), (bool) => assert(0), (double) => assert(0), (String_UTF8) => assert(0), () => assert(0));
}
