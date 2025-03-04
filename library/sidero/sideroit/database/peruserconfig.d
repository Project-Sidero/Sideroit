module sidero.sideroit.database.peruserconfig;
import sidero.sideroit.messages;
import sidero.base.path.file;
import sidero.base.text;
import sidero.base.system;

export @safe nothrow @nogc:

struct PerUserConfig {
    FilePath perUserDir;
}

/**
    $SIDEROIT_HOME
    $DPATH
    /etc/sideroit/
    ~/.sideroit/
    %LOCALAPPDATA%/sideroit/
*/
void loadPerUserConfig(out PerUserConfig config) {
    MessageBuilder messages = MessageBuilder("CONFIG LOADER");
    bool oneLoaded;

    {
        // TODO: assign defaults
    }

    void seeRoot(FilePath root, bool useAppNameForConfigFile, bool autocreate = false, bool isUserDir = false) @trusted {
        import sidero.eventloop.filesystem.introspection;
        import sidero.eventloop.filesystem.operations;
        import sidero.eventloop.filesystem.utils;
        import sidero.fileformats.json5;

        if(!root.isAbsolute) {
            if(!root.makeAbsolute) {
                messages.warningln("Could not make root path absolute {:s}", root);
                return;
            }
        }

        if(!isDirectory(root)) {
            if(!autocreate)
                return;

            auto error = mkdir(root);
            if(!error) {
                messages.warningln("Could not create the root directory {:s} due to {:s}", root, error);
                return;
            }
        }

        FilePath settingsFile = root.dup;

        if(useAppNameForConfigFile) {
            auto cliargs = commandLineArguments;

            if(cliargs.length == 0) {
                messages.fatalln("Global state for global arguments in not valid");
                return;
            }

            auto executable = cliargs[0];
            assert(executable);

            cast(void)(settingsFile ~= executable ~ ".json5");
        } else
            cast(void)(settingsFile ~= "settings.json5");

        if(autocreate && !isFile(settingsFile)) {
            write(settingsFile, String_UTF8(q{{
// Sideroit build manager configuration file
// https://github.com/Project-Sidero/sideroit

// Nothing here so far!
}})).blockUntilCompleteOrHaveValue;

            if(isUserDir)
                config.perUserDir = root;
            return;
        }

        if(!isFile(settingsFile))
            return;

        if(isUserDir)
            config.perUserDir = root;

        {
            ErrorSinkRef_StringBuilder errorSink = ErrorSinkRef_StringBuilder.make;

            auto rootJson = readJSON5(settingsFile, cast(ErrorSinkRef)errorSink);
            rootJson.blockUntilCompleteOrHaveValue;

            if(errorSink.haveError) {
                messages.error("", errorSink.builder);
                return;
            }

            auto rootObj = rootJson.result;
            if(!rootObj) {
                // empty configuration, this is ok.

                messages.warningln("Corrupt user configuration file for Sideroit at ", settingsFile);
                messages.warning("", errorSink.builder);
                return;
            }

            // TODO: evaluate tree
            oneLoaded = true;
        }
    }

    {
        String_UTF8 root = EnvironmentVariables[String_UTF8("SIDEROIT_HOME")];
        if(root.length > 0) {
            auto temp = FilePath.from(root);

            if(temp && !temp.isNull) {
                seeRoot(temp, false);
            }
        }
    }

    {
        String_UTF8 root = EnvironmentVariables[String_UTF8("DPATH")];
        if(root.length > 0) {
            auto temp = FilePath.from(root);

            if(temp && !temp.isNull) {
                seeRoot(temp, true);
            }
        }
    }

    version(Posix) {
        {
            auto temp = FilePath.from("/etc/sideroit/");

            if(temp && !temp.isNull) {
                seeRoot(temp, false);
            }
        }
    }

    version(Windows) {
        {
            String_UTF8 root = EnvironmentVariables[String_UTF8("LOCALAPPDATA")];
            if(root.length > 0) {
                auto temp = FilePath.from(root);

                if(temp && !temp.isNull) {
                    cast(void)(temp ~= "sideroit");
                    seeRoot(temp, false, true, true);
                }
            }
        }
    } else {
        {
            auto temp = FilePath.from("~/.sideroit/");

            if(temp && !temp.isNull) {
                seeRoot(temp, false, true, true);
            }
        }
    }

    if(!oneLoaded) {
        messages.errorln("Could not load any configurations for Sideroit");
    }
}
