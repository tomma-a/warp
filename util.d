module util;
import std.stdio;
import std.array;
import std.format;

import loc;

// Data type for C source code characters
alias ubyte uchar;
alias immutable(uchar)[] ustring;

void err_fatal(T...)(T args)
{
    auto app = appender!string();
    app.formattedWrite(args);
    throw new Exception(app.data);
}

void err_warning(T...)(Loc loc, T args)
{ 
    File f;
	f.fdopen(2,"w");
    loc.write(&(f));
    stderr.write("warning: ");
    stderr.writefln(args);
}
