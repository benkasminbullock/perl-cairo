#!/usr/bin/perl

#
# $Header$
#

use strict;
use warnings;
use Cairo;

use constant 
{
	IMG_WIDTH => 640,
	IMG_HEIGHT => 480,
	M_PI => 3.14159265,
};

die "png backend not supported" unless ($Cairo::backends{png});

$0 =~ /(.*)\.pl/;
my $png = "$1.png";

open OUT, ">$png" or die "unable to open ($png) for output";

my $cr = Cairo->create;
$cr->set_target_png (*OUT, 'ARGB32', IMG_WIDTH, IMG_HEIGHT);

$cr->rectangle (0, 0, IMG_WIDTH, IMG_HEIGHT);
$cr->set_rgb_color (1, 1, 1);
$cr->fill;

$cr->set_alpha (0.5);

# black
$cr->save;
$cr->set_rgb_color (0, 0, 0);
$cr->translate (IMG_WIDTH / 2, IMG_HEIGHT - (IMG_HEIGHT / 4));
do_star ();
$cr->restore;

# red
$cr->save;
$cr->set_rgb_color (1, 0, 0);
$cr->translate (IMG_WIDTH / 2, IMG_HEIGHT / 4);
do_star ();
$cr->restore;

# green
$cr->save;
$cr->set_rgb_color (0, 1, 0);
$cr->translate (IMG_WIDTH / 4, IMG_HEIGHT / 2);
do_star ();
$cr->restore;

# blue
$cr->save;
$cr->set_rgb_color (0, 0, 1);
$cr->translate (IMG_WIDTH - (IMG_WIDTH / 4), IMG_HEIGHT / 2);
do_star ();
$cr->restore;

$cr->show_page;
close OUT;

sub do_star
{
	my $mx = IMG_WIDTH / 3.0;
	my $count = 100;
	foreach (0..$count-1)
	{
		$cr->new_path;
		$cr->move_to (0, 0);
		$cr->rel_line_to (-$mx, 0);
		$cr->stroke;
		$cr->rotate ((M_PI * 2) / $count);
	}
}
