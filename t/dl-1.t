#!/usr/bin/env  perl
use strict;

use Test::More tests => 2;
use File::Basename;
use File::Temp qw(tempdir);

use_ok('Dynamic::Loader' );

my $fconfig=dirname($0);


my $ret=system("perl -MDynamic::Loader='module.pl --a=A --b=B',$ENV{PWD}/t -e ''");
ok($ret==0, "perl -MDynamic::Loader='module.pl --a=A --b=B',$ENV{PWD}/t -e ''");
#ok($ret==0, "perl script/loader.pl module.pl --a=A --b=B");

