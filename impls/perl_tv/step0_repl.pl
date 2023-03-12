#!/usr/bin/perl

use strict;
use warnings;
use Term::ReadLine; # https://perldoc.perl.org/Term::ReadLine



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

my $term = Term::ReadLine->new('Simple perl mal interpreter');
my $OUT = $term->OUT || \*STDOUT;
while (defined( $_ = $term->readline("user> ")) )
{
    print $OUT REP($_) . "\n";
    $term->addhistory($_) if /\S/;
}

