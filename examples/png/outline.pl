#!/usr/bin/perl

use strict;
use warnings;
use Cairo;

use constant
{
	WIDTH => 750,
	HEIGHT => 500,
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

	draw_outlines ($cr, WIDTH, HEIGHT);

	$cr->show_page;
	close OUT;
}

sub create_gradient
{
	my ($cr, $width, $height) = @_;

	my $gradient;
	my $matrix;
	my $gradient_pattern;

	$cr->save;

	$gradient = $cr->current_target_surface->create_similar
			('ARGB32', 3, 2);
	$cr->set_target_surface ($gradient);

	$cr->set_rgb_color (0, 0, 0);
	$cr->rectangle (0, 0, 1, 2);
	$cr->fill;

	$cr->set_rgb_color (1, 1, 1);
	$cr->rectangle (1, 0, 1, 2);
	$cr->fill;

	$cr->set_rgb_color (0, 0, 0);
	$cr->rectangle (2, 0, 1, 2);
	$cr->fill;

	$cr->restore;

	$matrix = Cairo::Matrix->create;
	$matrix->scale (2.0 / $width, 1.0 / $height);
	
	$gradient_pattern = Cairo::Pattern::->create_for_surface ($gradient);
	$gradient_pattern->set_matrix ($matrix);
	$gradient_pattern->set_filter ('BILINEAR');

	return $gradient_pattern;
}

sub draw_outlines
{
	my ($cr, $surface_width, $surface_height) = @_;

	my $gradient;
	my ($width, $height, $pad);

	$width = $surface_width / 4.0;
	$pad = ($surface_width - (3 * $width)) / 2.0;
	$height = $surface_height;

	$gradient = create_gradient ($cr, $width, $height);

	$cr->set_pattern ($gradient);
	draw_flat ($cr, $width, $height);

	$cr->translate ($width + $pad, 0);
	$cr->set_pattern ($gradient);
	draw_tent ($cr, $width, $height);

	$cr->translate ($width + $pad, 0);
	$cr->set_pattern ($gradient);
	draw_cylinder ($cr, $width, $height);

	$cr->restore;
}

sub draw_flat
{
	my ($cr, $width, $height) = @_;
	
	my $hwidth = $width / 2.0;

	$cr->rectangle (0, $hwidth, $width, $height - $hwidth);

	$cr->fill;
}

sub draw_tent
{
	my ($cr, $width, $height) = @_;

	my $hwidth = $width / 2.0;

	$cr->move_to     (       0,  $hwidth);
	$cr->rel_line_to ( $hwidth, -$hwidth);
	$cr->rel_line_to ( $hwidth,  $hwidth);
	$cr->rel_line_to (       0,  $height - $hwidth);
	$cr->rel_line_to (-$hwidth, -$hwidth);
	$cr->rel_line_to (-$hwidth,  $hwidth);
	$cr->close_path;

	$cr->fill;
}

sub draw_cylinder
{
	my ($cr, $width, $height) = @_;

	my $hwidth = $width / 2.0;

	$cr->move_to (0, $hwidth);
	$cr->rel_curve_to (0, -$hwidth, $width, -$hwidth, $width, 0);
	$cr->rel_line_to (0, $height - $hwidth);
	$cr->rel_curve_to (0, -$hwidth, -$width, -$hwidth, -$width, 0);
	$cr->close_path;

	$cr->fill;
}
