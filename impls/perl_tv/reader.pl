package Mal::Reader;

use strict;
use warnings;

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
	my $num_tokens = scalar @{ $self->{tokens} };
	if ($self->{position} >= $num_tokens)
	{
		print "unbalanced";
		exit 1;
	}
	# die("end of input") if $self->{position} >= $num_tokens;
	return $self->{ tokens }->[ $self->{position} ];
}

sub next
{
	my $self = shift;
	my $t = $self->peek();
	$self->{position}++;
	return $t;
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
		push( @$tokens, $1 );
	}
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
		if ($r->peek() eq ")")
		{
			$r->next(); # Klammer-zu wegtun
			return $mals;
		}
		push( @$mals, read_form( $r )); # richtig so?
	}
	return $mals;
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
