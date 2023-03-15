
while()
{
   print "user> ";
   my $s = <STDIN>;
   break unless $s;
   print `echo "$s" | xxd`;
}

