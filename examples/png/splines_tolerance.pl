#!/usr/bin/perl

use strict;
use warnings;
use Cairo;

use constant
{
	WIDTH => 600,
	HEIGHT => 300,
};

{
	my $cr;

	$cr = Cairo->create;

	$0 =~ /(.*)\.pl/;
	my $out = "$1.png";

	open OUT, ">$out" or die "unable to open ($out) for output";

	$cr->set_target_png (*OUT, 'ARGB32', WIDTH, HEIGHT);

	$cr->rectangle (0, 0, WIDTH, HEIGHT);
	$cr->set_rgb_color (1, 1, 1);
	$cr->fill;

	draw_splines ($cr, WIDTH, HEIGHT);

	$cr->show_page;
	close OUT;
}

sub draw_spline
{
	my ($cr, $height) = @_;

	$cr->move_to (0, .1 * $height);
	$height = .8 * $height;
	$cr->rel_curve_to (-$height / 2, $height / 2, $height / 2, $height / 2,
			   0, $height);
	$cr->stroke;
}

sub draw_splines
{
	my ($cr, $width, $height) = @_;

	my @tolerance = (.1, .5, 1, 5, 10);
	my $line_width = .08 * $width;
	my $gap = $width / 6;

	$cr->set_rgb_color (0, 0, 0);
	$cr->set_line_width ($line_width);

	$cr->translate ($gap, 0);
	for (my $i = 0; $i < 5; $i++)
	{
		$cr->set_tolerance ($tolerance[$i]);
		draw_spline ($cr, $height);
		$cr->translate ($gap, 0);
	}
}
