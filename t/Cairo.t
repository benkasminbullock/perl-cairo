#
# Copyright (c) 2004 by the cairo  perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;
use Data::Dumper;

use Test::More tests => 47;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

BEGIN
{
	use_ok ('Cairo');
}

# make sure there's something in there
ok (%Cairo::backends, '%Cairo::backends');

isa_ok (my $cr = Cairo->create, 'Cairo', 'create');
{
	isa_ok (my $copy = $cr->copy, 'Cairo', 'copy');
}

eval
{
	$cr->save;
	$cr->restore;
};
is ($@, '', '$cr->save|restore');

{
	my $surf = Cairo::Surface->image_create ('RGB24', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::Surface', 'support');

	$cr->set_target_surface ($surf);
	isa_ok ($cr->current_target_surface, 'Cairo::Surface',
		'$cr->set_target_surface');
	
	my $ptn = Cairo::Pattern->create_for_surface ($surf);
	$cr->set_pattern ($ptn);
	isa_ok ($cr->current_pattern, 'Cairo::Pattern',
		'$cr->set|current_pattern');
}

# TODO: $cr->set_target_image

$cr->set_operator ('CLEAR');
is ($cr->current_operator, 'CLEAR', '$cr->set|current_operator');

$cr->set_rgb_color (0.5, 0.6, 0.7);
is_deeply ([$cr->current_rgb_color], [0.5, 0.6, 0.7],
	  '$cr->set|current_rgb_color');

$cr->set_alpha (0.25);
is ($cr->current_alpha, 0.25, '$cr->set|current_alpha');

$cr->set_tolerance (0.75);
is ($cr->current_tolerance, 0.75, '$cr->set|current_tolerance');

$cr->set_fill_rule ('WINDING');
is ($cr->current_fill_rule, 'WINDING', '$cr->set|current_fill_rule');

$cr->set_line_width (3);
is ($cr->current_line_width, 3, '$cr->set|current_line_width');

$cr->set_line_cap ('BUTT');
is ($cr->current_line_cap, 'BUTT', '$cr->set|current_line_cap');

$cr->set_line_join ('MITER');
is ($cr->current_line_join, 'MITER', '$cr->set|current_line_join');

eval
{
	$cr->set_dash (0, 2, 4, 6, 4, 2);
};
is ($@, '', '$cr->set_dash');

$cr->set_miter_limit (2.2);
is ($cr->current_miter_limit, 2.2, '$cr->set|current_miter_limit');

eval
{
	$cr->translate (2.2, 3.3);
};
is ($@, '', '$cr->translate');

eval
{
	$cr->scale (2.2, 3.3);
};
is ($@, '', '$cr->scale');

eval
{
	$cr->rotate (2.2);
};
is ($@, '', '$cr->rotate');

eval
{
	$cr->default_matrix;
};
is ($@, '', '$cr->default_matrix');

eval
{
	$cr->identity_matrix;
};
is ($@, '', '$cr->identity_matrix');

{
	my $matrix = Cairo::Matrix->create;

	$matrix->set_affine (1.1, 2.2, 3.3, 4.4, 23, 34);

	$cr->set_matrix ($matrix);
	is_deeply ([$cr->current_matrix->get_affine], 
		   [ 1.1, 2.2, 3.3, 4.4, 23, 34 ], '$cr->current_matrix');

	eval
	{
		$cr->concat_matrix ($matrix);
	};
	is ($@, '', '$cr->concat_matrix');
}

{
	my ($x, $y) = (1.1, 2.2);
	is_deeply ([$cr->transform_point ($x, $y)], [209.747, 306.074],
		   '$cr->transform_point');
	
	is_deeply ([$cr->transform_distance ($x, $y)], [49.247, 71.874],
		   '$cr->transform_distance');
	
	my ($tx, $ty) = $cr->inverse_transform_point ($x, $y);
	$tx = int ($tx);
	$ty = int ($ty);
	is_deeply ([$tx, $ty], [-5, -6], '$cr->inverse_transform_point');
	
	($tx, $ty) = $cr->inverse_transform_distance ($x, $y);
	$tx = int ($tx);
	$ty = int ($ty);
	is_deeply ([$tx, $ty], [-1, 0], '$cr->inverse_transform_distance');
}

# img isn't going to be very interesting
my $outtmp = 't/out.tmp';
open OUT, '>'.$outtmp
	or die "failed to create output tmp file ($outtmp)";
ok (*OUT, 'OUT support');

SKIP:
{
	skip "png backend not supported in bound cairo", 1
		unless ($Cairo::backends{png});
	eval
	{
		$cr->set_target_png (*OUT, 'ARGB32', IMG_WIDTH, IMG_HEIGHT);
	};
	is ($@, '', '$cr->set_target_png');
}

# XXX: we have to set a backend ^ before doing the stuff below or we get
# segfaults
eval
{
	$cr->new_path;
	$cr->move_to (1.1, 2.2);
	$cr->line_to (2.2, 3.3);
	$cr->curve_to (3.3, 4.4, 5.5, 6.6, 7.7, 8.8);
	$cr->arc (4.4, 5.5, 6.6, 7.7, 8.8);
	$cr->arc (5.5, 6.6, 7.7, 8.8, 9.9);
	$cr->rel_move_to (6.6, 7.7);
	$cr->rel_line_to (8.8, 9.9);
	$cr->rel_curve_to (9.9, 0.0, 1.1, 2.2, 3.3, 4.4);
	$cr->rectangle (0.0, 1.1, 2.2, 3.3);

	$cr->close_path;

	my ($ex, $ey) = $cr->stroke_extents;
	$ex = int ($ex);
	$ey = int ($ey);
	is_deeply ([$ex, $ey], [-1, 0], '$cr->stroke_extents');
	
	($ex, $ey) = $cr->fill_extents;
	$ex = int ($ex);
	$ey = int ($ey);
	is_deeply ([$ex, $ey], [0, 1], '$cr->fill_extents');
	
	$cr->stroke;
	$cr->fill;

	$cr->copy_page;
	$cr->show_page;

	ok (! $cr->in_stroke (1.1, 2.2), '$cr->in_stroke');
	ok (! $cr->in_fill (2.2, 3.3), '$cr->in_fill');
};
is ($@, '', 'path/drawing funcs');

eval
{
#	$cr->init_clip;
#	$cr->clip;
};
is ($@, '', 'clip funcs');

eval
{
	$cr->select_font ('courier', 'NORMAL', 'NORMAL');
	$cr->scale_font (2);
	$cr->transform_font ($cr->current_matrix);
# XXX: if i call show text things abort
#	$cr->show_text ('Hello World');

	my $font = $cr->current_font;
	isa_ok ($font, 'Cairo::Font', '$cr->current_font');
	$cr->set_font ($font);

# XXX: lines 225 - 256 should be tested here
#	isa_ok ($cr->current_font_extents, 'Cairo::Font::Extents',
#		'$cr->current_font_extents');
};
is ($@, '', 'fonts');

{
	my $surf = Cairo::Surface->image_create ('RGB24', IMG_WIDTH, IMG_HEIGHT);
	eval
	{
		$cr->show_surface ($surf, IMG_WIDTH, IMG_HEIGHT);
	};
	is ($@, '', '$cr->show_surface');
}

is ($cr->status, 'SUCCESS', '$cr->status');

is ($cr->status_string, 'success', '$cr->status_string');

SKIP:
{
	# XXX:
	skip "ps backend currently hangs", 1;

	skip "ps backend not supported in bound cairo", 1
		unless ($Cairo::backends{ps});
	eval
	{
		$cr->set_target_ps (*OUT, IMG_WIDTH, IMG_HEIGHT, 72, 72);
	};
	is ($@, '', '$cr->set_target_ps');
}

SKIP:
{
	# XXX:
	skip "xlib backend no way to get display and drawable", 1;

	skip "xlib backend not supported in bound cairo", 1
		unless ($Cairo::backends{xlib});
	eval
	{
		$cr->set_target_drawable ();
	};
	is ($@, '', '$cr->set_target_xlib');
}

SKIP:
{
	skip "xcb backend not supported in bound cairo", 1
		unless ($Cairo::backends{xcb});
	eval
	{
		$cr->set_target_xcb ();
	};
	is ($@, '', '$cr->set_target_xcb');
}

SKIP:
{
	skip "glitz backend not supported in bound cairo", 1
		unless ($Cairo::backends{glitz});
	eval
	{
		$cr->set_target_glitz ();
	};
	is ($@, '', '$cr->set_target_glitz');
}

close OUT;

ok (unlink ($outtmp), 'rm tmpout');
