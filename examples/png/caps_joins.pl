#!/usr/bin/perl

use strict;
use warnings;
use Cairo;


use constant
{
	WIDTH => 600,
	HEIGHT => 600,
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

	draw_caps_joins ($cr, WIDTH, HEIGHT);

	$cr->show_page;
	close OUT;
}

sub stroke_v_twice
{
	my ($cr, $width, $height) = @_;

	$cr->move_to (0, 0);
	$cr->rel_line_to ($width / 2, $height / 2);
	$cr->rel_line_to ($width / 2, - $height / 2);

	$cr->save;
	$cr->stroke;
	$cr->restore;

	$cr->save;
	{
		$cr->set_line_width (2.0);
		$cr->set_line_cap ('BUTT');
		$cr->set_rgb_color (1, 1, 1);
		$cr->stroke;
	}
	$cr->restore;

	$cr->new_path;
}

sub draw_caps_joins
{
	my ($cr, $width, $height) = @_;

	my $line_width = $height / 12 & (~1);

	$cr->set_line_width ($line_width);
	$cr->set_rgb_color (0, 0, 0);

	$cr->translate ($line_width, $line_width);
	$width -= 2 * $line_width;

	$cr->set_line_join ('BEVEL');
	$cr->set_line_cap ('BUTT');
	stroke_v_twice ($cr, $width, $height);

	$cr->translate (0, $height / 4 - $line_width);
	$cr->set_line_join ('MITER');
	$cr->set_line_cap ('SQUARE');
	stroke_v_twice ($cr, $width, $height);

	$cr->translate (0, $height / 4 - $line_width);
	$cr->set_line_join ('ROUND');
	$cr->set_line_cap ('ROUND');
	stroke_v_twice ($cr, $width, $height);
}



