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

use Test::More tests => 12;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

isa_ok (my $surf = Cairo::Surface->image_create ('RGB24', IMG_WIDTH,
						 IMG_HEIGHT),
	'Cairo::Surface');

{
	isa_ok ($surf->create_similar ('RGB24', IMG_WIDTH, IMG_HEIGHT),
		'Cairo::Surface', '$surf->create_similar');
}

eval
{
	$surf->set_repeat (1);
};
is ($@, '', '$sufr->set_repeate');

{
	my $matrix = Cairo::Matrix->create;
	$surf->set_matrix ($matrix);
	isa_ok ($surf->get_matrix, 'Cairo::Matrix', '$surf->set|get_matrix');
}

$surf->set_filter ('FAST');
is ($surf->get_filter, 'FAST', '$surf->set|get_filter');

# img isn't going to be very interesting
my $outtmp = 't/out.tmp';
open OUT, '>'.$outtmp
	or die "failed to create output tmp file ($outtmp)";
ok (*OUT, 'OUT support');

SKIP:
{
	skip "png backend not supported in bound cairo", 1
		unless ($Cairo::backends{png});
	isa_ok (Cairo::Surface->png_create (*OUT, 'ARGB32', IMG_WIDTH, 
					    IMG_HEIGHT), 'Cairo::Surface');
}

SKIP:
{
	# XXX:
	skip "ps backend currently hangs", 1;

	skip "ps backend not supported in bound cairo", 1
		unless ($Cairo::backends{ps});
	isa_ok (Cairo::Surface->ps_create (*OUT, IMG_WIDTH, IMG_HEIGHT,
					   72, 72), 'Cairo::Surface');
}

SKIP:
{
	# XXX:
	skip "xlib backend no way to get display and drawable", 1;

	skip "xlib backend not supported in bound cairo", 1
		unless ($Cairo::backends{xlib});
	isa_ok (Cairo::Surface->xlib_create (), 'Cairo::Surface');
}

SKIP:
{
	skip "xcb backend not supported in bound cairo", 1
		unless ($Cairo::backends{xcb});
	isa_ok (Cairo::Surface->xcb_create (), 'Cairo::Surface');
}

SKIP:
{
	skip "glitz backend not supported in bound cairo", 1
		unless ($Cairo::backends{glitz});
	isa_ok (Cairo::Surface->glitz_create (), 'Cairo::Surface');
}

close OUT;

ok (unlink ($outtmp), 'rm tmpout');
