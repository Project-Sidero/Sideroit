module sidero.sideroit.messages;
import sidero.base.text;
import sidero.base.console;
public import sidero.base.logger : LogLevel;

export @safe nothrow @nogc:

__gshared LogLevel defaultLogLevel = LogLevel.Notice;

/// Per thread
struct MessageBuilder {
    private {
        StringBuilder_UTF8 builder;
        StringBuilder_UTF8 component;
        LogLevel currentLevel;
        bool haveError_;
    }

export @safe nothrow @nogc:

    ///
    this(string component) @trusted {
        this.component ~= "[";
        this.component ~= component;
        this.component ~= "] ";

        this.currentLevel = defaultLogLevel;
    }

    @disable this(this);

    ~this() {
        complete;
    }

    bool haveError() {
        return this.haveError_;
    }

    ///
    void print(Args...)(LogLevel logLevel, string format, Args args) {
        checkLevel(logLevel);
        builder.formattedWrite(format, args);
    }

    ///
    void println(Args...)(LogLevel logLevel, string format, Args args) {
        checkLevel(logLevel);

        builder.formattedWrite(format, args);
        if(!builder.endsWith("\n"))
            builder ~= "\r\n";
    }

    ///
    void trace(Args...)(string format, Args args) {
        print(LogLevel.Trace, format, args);
    }

    ///
    void traceln(Args...)(string format, Args args) {
        println(LogLevel.Trace, format, args);
    }

    ///
    void debug_(Args...)(string format, Args args) {
        print(LogLevel.Debug, format, args);
    }

    ///
    void debugln(Args...)(string format, Args args) {
        println(LogLevel.Debug, format, args);
    }

    ///
    alias info = information;

    ///
    alias infoln = informationln;

    ///
    void information(Args...)(string format, Args args) {
        print(LogLevel.Info, format, args);
    }

    ///
    void informationln(Args...)(string format, Args args) {
        println(LogLevel.Info, format, args);
    }

    ///
    void notice(Args...)(string format, Args args) {
        print(LogLevel.Notice, format, args);
    }

    ///
    void noticeln(Args...)(string format, Args args) {
        println(LogLevel.Notice, format, args);
    }

    ///
    alias warn = warning;

    ///
    alias warnln = warningln;

    ///
    void warning(Args...)(string format, Args args) {
        print(LogLevel.Warning, format, args);
    }

    ///
    void warningln(Args...)(string format, Args args) {
        println(LogLevel.Warning, format, args);
    }

    ///
    void error(Args...)(string format, Args args) {
        print(LogLevel.Error, format, args);
        haveError_ = true;
    }

    ///
    void errorln(Args...)(string format, Args args) {
        println(LogLevel.Error, format, args);
        haveError_ = true;
    }

    ///
    void critical(Args...)(string format, Args args) {
        print(LogLevel.Critical, format, args);
    }

    ///
    void criticalln(Args...)(string format, Args args) {
        println(LogLevel.Critical, format, args);
    }

    ///
    void fatal(Args...)(string format, Args args) {
        print(LogLevel.Fatal, format, args);
        haveError_ = true;
    }

    ///
    void fatalln(Args...)(string format, Args args) {
        println(LogLevel.Fatal, format, args);
        haveError_ = true;
    }

    ///
    void complete() {
        if(this.builder.length == 0)
            return;

        StringBuilder_UTF8 temp = this.builder;

        do {
            temp.prepend(component);

            ptrdiff_t index = temp.indexOf("\n");
            if(index < 0)
                break;
            temp = temp[index + 1 .. $];
        }
        while(temp.length > 0);

        if (haveError_)
            write(foreground(ConsoleColor.Red), builder, resetDefaultBeforeApplying());
        else
            write(builder);

        builder = StringBuilder_UTF8.init;
    }

private:

    void checkLevel()(LogLevel newLevel) {
        if(this.currentLevel != newLevel && this.builder.length > 0)
            complete;
        this.currentLevel = newLevel;
    }
}
