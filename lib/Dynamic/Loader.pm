package Dynamic::Loader;

require Exporter;
use warnings;
use strict;
use File::Basename;


=head1 NAME

Dynamic::Loader - call a script without to know where is his location.

=head1 VERSION

Version 0.01

=cut
our ($VERSION, $javaperl, @ISA, @EXPORT);
$VERSION = '0.12';
@ISA = qw(Exporter);
@EXPORT=qw($javaperl getscriptenv);

my $scriptlib;
my $scriptbin;
my $confpath;

=head1 SYNOPSIS

    The Dynamic::Loader manage the dynamic location of scripts and bundles. 
    Scripts and bundles are packaged in there own directory.
    The bundles and scripts locations are discribed on a named configuration file. 
    The prefix configuration directory can be specified by the $JAVAPERL environnement. 
    The default directory is $HOME/.perljava/conf, but you can specify a custom
    prefix with the $JAVAPERL/conf variable.
    
    A configuration is <name>.conf with this format:
        prefix=<absolute path>
        bin=<relative binary dir>
        lib=<relative library dir>

    You can use two methods to call a script:
        perl -MDynamic::Loader='scriptname.pl --a=... --b=...'
        perl -S loader.pl scriptname.pl --a=... --b=...

=head1 DEFAULT SCRIPT AND PARAMS

When C<Dynamic::Loader> is used, you can specify the script name and his options
command:

    % perl -MDynamic::Loader='scriptname.pl --a=A --b=B'

=head1 DEFAULT MODULE CONF PATH

Configuration directory is specified by the environment variable JAVAPERL or at 
HOME/.perljava/conf. The prefix location can also specified by the command line:

    % perl -MDynamic::Loader='scriptname.pl --a=A --b=B',/dir/to/packages


=head1 EXPORT



=cut

sub readfile{
    my ( $f ) = @_;
    open F, "< $f" or die "Can't open $f : $!";
    my @f = <F>;
    close F;
    return @f;
}
    
sub init{
    my @config=();
    
    push (@config, $confpath) if defined $confpath;
    push (@config, $ENV{JAVAPERL}) if defined $ENV{JAVAPERL};
    push (@config, "$ENV{HOME}/.perljava/conf/");

    #FIXME basename is not a good idea (ex: manage/showPouet.pl)
    my $script=basename($0) if $0=~/.*\.pl/;

    #load plugins config 
    foreach my $path (@config){
        if (-d "$path"){
            opendir(DIR, $path);
            my @dir=readdir(DIR);
            closedir(DIR);
            my @conffiles = grep(/\.conf$/,@dir);
#            my @pmfiles = grep(/\.pm$/,@dir);
#            foreach my $c (@pmfiles){
#                print STDERR "DEBUG: -->$path/$c\n";
#                do  "$path/$c";
#            }
            foreach my $c (@conffiles){;
                my $bname=basename($c);
                $bname=~ s/.conf$//m;
                my @conf=readfile "$path/$c";
                my %lastentry;
                
                foreach my $l (@conf){
                    $l=~/(^[\w\.]+?)=(.+)$/;
                    $lastentry{$1}=$2 if ($1 && $2);
                }
                if (%lastentry){
                    $javaperl->{"$bname"}=\%lastentry;
                
                    #if script exist setup the lib path
                    if ( $lastentry{'prefix'} && $lastentry{'bin'} && $lastentry{'lib'} && $script &&
                        -r $lastentry{'prefix'}.$lastentry{'bin'}."/$script"){
                        $scriptbin=$lastentry{'prefix'}.$lastentry{'bin'}."/$script";
                        $scriptlib=$lastentry{'prefix'}.$lastentry{'lib'};
                    }
                }
                
                
            }
            goto OUT;
        }
    }
    OUT:
}
# Hook on export recursion, 
# Script and params could be defined on import module
#  perl -MDynamic::Loader='scriptname.pl --params ...'
#
# this is a method to call a script without to know where are his bundles and binary
# this part setup env to autorun command whitout using the loader.pl prefix.
my $autorun;
sub import {
    my $class=shift;
    if (@_ && defined $_[1] && -d $_[1]){
        $confpath=$_[1];
        delete $_[1];
    }
    init();
    #be sure to not modify @_ before the end of export chain
    if (@_ && $_[0]=~/.*\.pl/){
        my @M=split(' ',$_[0]);
        ($scriptlib,$scriptbin)=getscriptenv(shift(@M));
	    foreach my $a (@M){
        	$autorun.=$a;
	    }
	    $autorun= ' ' unless $autorun;
        shift(@_);    	
    }
    $class->export_to_level(1, $class, @_) ;    	
}

#call script configured by import.
END{
    exit system("perl -I$scriptlib $scriptbin $autorun") if defined($autorun);
}


#looking for a script
sub getscriptenv{
    my ($script)=@_;
    return ($scriptlib,$scriptbin) if ($scriptlib && $scriptbin);

    foreach my $mod (keys %{$javaperl}){
        my $prefix="$javaperl->{$mod}->{'prefix'}/";
        my $bin=$prefix.$javaperl->{$mod}->{'bin'}."/$script" if defined($javaperl->{$mod}->{'bin'});
        my $inc=$prefix.$javaperl->{$mod}->{'lib'}if defined($javaperl->{$mod}->{'lib'});
        if (defined($bin) && -r $bin){
            return ($inc, $bin);
        }
        
    }
    
    die "ERROR: Cannot open executable $script (No such file)\n";
}



=head1 AUTHOR

Olivier Evalet, C<< <olivier.evalet at genebio.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dynamic-loader at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dynamic-Loader>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dynamic::Loader


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dynamic-Loader>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dynamic-Loader>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dynamic-Loader>

=item * Search CPAN

L<http://search.cpan.org/dist/Dynamic-Loader>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Olivier Evalet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut




1; # End of Dynamic::Loader
