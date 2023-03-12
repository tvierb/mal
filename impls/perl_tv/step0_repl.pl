use strict;
use warnings;


# read
sub READ {
    my $str = shift;
    return $str;
}

# eval
sub EVAL {
    my($ast, $env) = @_;
    return $ast;
}

# print
sub PRINT {
    my $exp = shift;
    return $exp;
}

# repl
sub REP {
    my $str = shift;
    return PRINT(EVAL(READ($str), {}));
}

while (1) {
    print "user> ";
    my $line = <STDIN>;
    if (! defined $line) { last; }
    print(REP($line), "\n");
}
