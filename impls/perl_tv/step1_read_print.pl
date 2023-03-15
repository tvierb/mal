#!/usr/bin/perl

package main;

use strict;
use warnings;
use Term::ReadLine; # https://perldoc.perl.org/Term::ReadLine
use lib ".";
require "reader.pl";
require "printer.pl";

my $debugging = 1;
# read
sub READ {
    my $str = shift;
    return read_str( $str );
}

# eval
sub EVAL {
    my($ast, $env) = @_;
    return $ast;
}

# print
sub PRINT {
	my $exp = shift;
	return pr_str( $exp );
}

# repl
sub REP {
    my $str = shift;
    return PRINT(EVAL(READ($str), {}));
}

my $term = Term::ReadLine->new('Simple perl mal interpreter');
#my $OUT = $term->OUT || \*STDOUT;
#while (defined( $_ = $term->readline("user> ")) )
#{
	#    print $OUT REP($_) . "\n";
	 #    $term->addhistory($_) if /\S/;
#}

while (1)
{
	print("user> ");
	$_ = <STDIN>;
	exit(0) unless defined($_);
    print STDOUT REP($_) . "\n";
}
