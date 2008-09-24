#!/usr/bin/env  perl
use strict;

use Test::More tests => 2;
use File::Basename;
use File::Temp qw(tempdir);
use Env::Path;
use_ok('Dynamic::Loader' );

my $fconfig=dirname($0);

our $JAVAPERL = Env::Path->JAVAPERL;
$JAVAPERL->Prepend("$ENV{PWD}/t");

print "JAVAPERL='$ENV{PWD}/t' perl scripts/fromjar.pl module.pl --a=A --b=B";
my $ret=int(system("perl scripts/fromjar.pl module.pl --a=A --b=B")/256);
ok($ret==123, "perl scripts/fromjar.pl module.pl --a=A --b=B");

