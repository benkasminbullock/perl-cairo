#!/usr/bin/perl

use strict;
use warnings;
use Cairo;


use constant
{
	WIDTH => 300,
	HEIGHT => 600,
	LINES => 32,
	M_PI_2 => 3.14159265 / 2.0,
};

use constant
{
	MAX_THETA => (.80 * M_PI_2),
};

use constant
{
	THETA_INC => (2.0 * MAX_THETA / (LINES-1)),
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

	draw_hering ($cr, WIDTH, HEIGHT);

	$cr->show_page;
	close OUT;
}

sub draw_hering
{
	my ($cr, $width, $height) = @_;

	$cr->set_rgb_color (0, 0, 0);
	$cr->set_line_width (2.0);

	$cr->save;
	{
		$cr->translate ($width / 2, $height / 2);
		$cr->rotate (MAX_THETA);
	
		for (my $i=0; $i < LINES; $i++)
		{
		$cr->move_to (-2 * $width, 0);
		$cr->line_to (2 * $width, 0);
		$cr->stroke;
		
		$cr->rotate (- THETA_INC);
		}
	}
	$cr->restore;

	$cr->set_line_width (6);
	$cr->set_rgb_color (1, 0, 0);

	$cr->move_to ($width / 4, 0);
	$cr->rel_line_to (0, $height);
	$cr->stroke;

	$cr->move_to (3 * $width / 4, 0);
	$cr->rel_line_to (0, $height);
	$cr->stroke;
}
