module sidero.sideroit.database.utils;
import sidero.base.path.file;
import sidero.base.text;
import sidero.base.system;

/**
    $SIDEROIT_HOME
    $DPATH
    /etc/sideroit/
    ~/.sideroit/
    %LOCALAPPDATA%/sideroit/
*/
void loadSideroitConfig(out SideroitConfig config) {
    bool oneLoaded;

    {
        // TODO: assign defaults
    }

    void seeRoot(FilePath root, bool useAppNameForConfigFile, bool autocreate = false, bool isUserDir=false) {
        import sidero.eventloop.filesystem.introspection;
        import sidero.eventloop.filesystem.operations;
        import sidero.eventloop.filesystem.utils;
        import sidero.fileformats.json5;
        import sidero.base.text.processing.errors;

        if(!root.isAbsolute) {
            if(!root.makeAbsolute) {
                // TODO: error
                return;
            }
        }

        if(!isDirectory(root)) {
            if(!autocreate)
                return;

            if(!mkdir(root)) {
                // TODO: error
                return;
            }
        }

        FilePath settingsFile = root.dup;

        if(useAppNameForConfigFile) {
            auto cliargs = commandLineArguments;

            if(cliargs.length == 0) {
                // TODO: error
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
            return;
        }

        if(!isFile(settingsFile))
            return;

        if (isUserDir) {
            // TODO: assign root directory as user config dir
        }

        {
            ErrorSinkRef_Console errorSink = ErrorSinkRef_Console.make; // FIXME: move this!

            auto rootJson = readJSON5(settingsFile, cast(ErrorSinkRef)errorSink);
            rootJson.blockUntilCompleteOrHaveValue;

            if(errorSink.haveError) {
                // TODO: error
                return;
            }

            auto rootObj = rootJson.result;
            if(!rootObj) {
                // TODO: error
                return;
            }

            // TODO: evaluate tree
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
        // TODO: error
    }
}

struct SideroitConfig {

}
