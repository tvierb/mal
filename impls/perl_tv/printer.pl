package main;

use strict;
use warnings;
use Data::Dumper;

sub pr_str
{
	my $mals = shift;
	my $s = "";
	if (ref $mals eq "ARRAY")
	{
		my $s = "(";
		map { $s .= (length($s) > 1 ? " " : "") . pr_str( $_ ) } @$mals;
		return "$s)";
	}

	if (defined($mals->{type}))
	{
		return $mals->{ value }; # . ":" . $mals->{type};
	}

	die("pr_str: mal is neither list nor mal data type: " . Dumper( $mals ));
}
 1;

