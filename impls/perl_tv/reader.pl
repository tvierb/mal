package Mal::Reader;

use strict;
use warnings;
$|=1;

sub new
{
	my $class = shift;
	my $self = {position => 0, tokens => []};
	$self = bless($self, $class);
	return $self;
}

sub peek
{
	my $self = shift;
	# die("end of input: nothing to peek") if $self->{position} >= scalar @{ $self->{tokens} };
	return $self->{ tokens }->[ $self->{position} ];
}

sub next
{
	my $self = shift;
	# die("end of input: cannot increase position") if $self->{position} >= scalar @{ $self->{tokens} };
	return $self->{ tokens }->[ $self->{position}++ ];
}

package main;

use strict;
use warnings;
use Data::Dumper;

sub read_str
{
	my $s = shift;
	# print "reading string '$s'\n";
	my $tokens = tokenize( $s );
	# print "tokens: " . Dumper( $tokens );
	my $r = Mal::Reader->new();
	$r->{ tokens } = $tokens;
	return read_form( $r );
}

sub tokenize
{
	my $s = shift;
	my $tokens = [];
	while ($s =~ /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/g)
	{
		push( @$tokens, $1 ) if length($1);
	}
	# print Dumper( $tokens);
	return $tokens;
}

sub read_form
{
	my $r = shift;
	my $t = $r->peek();
	if (substr($t, 0,1) eq "(")
	{
		return read_list( $r ); # return {type => "list", value => read_list( $r ) };
	}
	return read_atom( $r ); # return {type => "atom", value => read_atom( $r ) };
}

sub read_list
{
	my $r = shift;
	my $mals = []; # Liste, in die die Atome und weiteren Listen kommen
	my $t = $r->next(); # Klammer wegtun
	while(1)
	{
		$t = $r->peek();
		unless (defined($t))
		{
			print "end of input in read_list\n";
			exit(1);
		}
		if ($t eq ")")
		{
			$r->next();
			return $mals;
		}
		push( @$mals, read_form( $r ) );
	}
}

sub read_atom
{
	my $r = shift;
	my $t = $r->next();
	if ($t =~ /^[1-9]+[0-9]*$/)
	{
		return {type => "number", value => $t};
	}
	return {type => "symbol", value => $t};
}

1;
