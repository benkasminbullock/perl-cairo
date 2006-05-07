#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 21;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
isa_ok ($surf, 'Cairo::ImageSurface');
isa_ok ($surf, 'Cairo::Surface');

$surf = Cairo::ImageSurface->create_for_data ('Urgs!', 'rgb24',
                                              IMG_WIDTH, IMG_HEIGHT, 23);
isa_ok ($surf, 'Cairo::ImageSurface');
isa_ok ($surf, 'Cairo::Surface');

$surf = $surf->create_similar ('color', IMG_WIDTH, IMG_HEIGHT);
isa_ok ($surf, 'Cairo::ImageSurface');
isa_ok ($surf, 'Cairo::Surface');

$surf->set_device_offset (23, 42);
is_deeply ([$surf->get_device_offset], [23, 42]);

is ($surf->status, 'success');
is ($surf->get_type, 'image');

$surf->finish;

isa_ok ($surf->get_font_options, 'Cairo::FontOptions');

$surf->mark_dirty;
$surf->mark_dirty_rectangle (10, 10, 10, 10);
$surf->flush;

SKIP: {
	skip 'png surface', 3
		unless Cairo::HAS_PNG_FUNCTIONS;

	$surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
	is ($surf->write_to_png ('tmp.png'), 'success');

	$surf = Cairo::ImageSurface->create_from_png ('tmp.png');
	isa_ok ($surf, 'Cairo::ImageSurface');
	isa_ok ($surf, 'Cairo::Surface');

	unlink 'tmp.png';
}

SKIP: {
	skip 'pdf surface', 4
		unless Cairo::HAS_PDF_SURFACE;

	$surf = Cairo::PdfSurface->create ('tmp.pdf', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::PdfSurface');
	isa_ok ($surf, 'Cairo::Surface');

	$surf->set_dpi (72, 72);
	$surf->set_size (23, 42);

	$surf = $surf->create_similar ('alpha', IMG_WIDTH, IMG_HEIGHT);
	# the pdf backend falls back to an image surface currently
	isa_ok ($surf, 'Cairo::ImageSurface');
	isa_ok ($surf, 'Cairo::Surface');

	unlink 'tmp.pdf';
}

SKIP: {
	skip 'ps surface', 4
		unless Cairo::HAS_PS_SURFACE;

	$surf = Cairo::PsSurface->create ('tmp.ps', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::PsSurface');
	isa_ok ($surf, 'Cairo::Surface');

	$surf->set_dpi (72, 72);
	$surf->set_size (23, 42);
	
	$surf->dsc_comment("Bla?");
	$surf->dsc_begin_setup;
	$surf->dsc_begin_page_setup;

	$surf = $surf->create_similar ('alpha', IMG_WIDTH, IMG_HEIGHT);
	# the ps backend falls back to an image surface currently
	isa_ok ($surf, 'Cairo::ImageSurface');
	isa_ok ($surf, 'Cairo::Surface');

	unlink 'tmp.ps';
}
