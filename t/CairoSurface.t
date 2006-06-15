#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;

use Test::More tests => 48;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

use Cairo;

my $surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
isa_ok ($surf, 'Cairo::ImageSurface');
isa_ok ($surf, 'Cairo::Surface');
is ($surf->get_content, 'color');

is ($surf->get_format, 'rgb24');
is ($surf->get_width, IMG_WIDTH);
is ($surf->get_height, IMG_HEIGHT);

$surf = Cairo::ImageSurface->create_for_data ('Urgs!', 'rgb24',
                                              IMG_WIDTH, IMG_HEIGHT, 23);
isa_ok ($surf, 'Cairo::ImageSurface');
isa_ok ($surf, 'Cairo::Surface');

is ($surf->get_data, 'Urgs!');
is ($surf->get_stride, 23);

$surf = $surf->create_similar ('color', IMG_WIDTH, IMG_HEIGHT);
isa_ok ($surf, 'Cairo::ImageSurface');
isa_ok ($surf, 'Cairo::Surface');

$surf->set_device_offset (23, 42);
is_deeply ([$surf->get_device_offset], [23, 42]);

$surf->set_fallback_resolution (72, 72);

is ($surf->status, 'success');
is ($surf->get_type, 'image');

isa_ok ($surf->get_font_options, 'Cairo::FontOptions');

$surf->mark_dirty;
$surf->mark_dirty_rectangle (10, 10, 10, 10);
$surf->flush;

SKIP: {
	skip 'png surface', 16
		unless Cairo::HAS_PNG_FUNCTIONS;

	$surf = Cairo::ImageSurface->create ('rgb24', IMG_WIDTH, IMG_HEIGHT);
	is ($surf->write_to_png ('tmp.png'), 'success');

	is ($surf->write_to_png_stream (sub {
		my ($closure, $data) = @_;
		is ($closure, 'blub');
		like ($data, qr/PNG/);
		die 'write-error';
	}, 'blub'), 'no-memory');

	is ($surf->write_to_png_stream (sub {
		my ($closure, $data) = @_;
		is ($closure, undef);
		like ($data, qr/PNG/);
		die 'write-error';
	}), 'no-memory');

	$surf = Cairo::ImageSurface->create_from_png ('tmp.png');
	isa_ok ($surf, 'Cairo::ImageSurface');
	isa_ok ($surf, 'Cairo::Surface');

	open my $fh, 'tmp.png';
	$surf = Cairo::ImageSurface->create_from_png_stream (sub {
		my ($closure, $length) = @_;
		my $buffer;

		if ($length != sysread($fh, $buffer, $length)) {
			die 'no-memory';
		}

		return $buffer;
	});
	isa_ok ($surf, 'Cairo::ImageSurface');
	isa_ok ($surf, 'Cairo::Surface');
	is ($surf->status, 'success');
	close $fh;

	$surf = Cairo::ImageSurface->create_from_png_stream (sub {
		my ($closure, $length) = @_;
		is ($closure, 'blub');
		die 'read-error';
	}, 'blub');
	TODO: {
		local $TODO = "create_from_png_stream trouble";
		isa_ok ($surf, 'Cairo::ImageSurface');
	}
	isa_ok ($surf, 'Cairo::Surface');
	is ($surf->status, 'read-error');

	unlink 'tmp.png';
}

SKIP: {
	skip 'pdf surface', 8
		unless Cairo::HAS_PDF_SURFACE;

	$surf = Cairo::PdfSurface->create ('tmp.pdf', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::PdfSurface');
	isa_ok ($surf, 'Cairo::Surface');

	$surf->set_size (23, 42);

	$surf = $surf->create_similar ('alpha', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::ImageSurface');
	isa_ok ($surf, 'Cairo::Surface');

	unlink 'tmp.pdf';

	$surf = Cairo::PdfSurface->create_for_stream (sub {
		my ($closure, $data) = @_;
		is ($closure, 'blub');
		like ($data, qr/PDF/);
		die 'write-error';
	}, 'blub', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::PdfSurface');
	isa_ok ($surf, 'Cairo::Surface');
}

SKIP: {
	skip 'ps surface', 8
		unless Cairo::HAS_PS_SURFACE;

	$surf = Cairo::PsSurface->create ('tmp.ps', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::PsSurface');
	isa_ok ($surf, 'Cairo::Surface');

	$surf->set_size (23, 42);

	$surf->dsc_comment("Bla?");
	$surf->dsc_begin_setup;
	$surf->dsc_begin_page_setup;

	$surf = $surf->create_similar ('alpha', IMG_WIDTH, IMG_HEIGHT);
	TODO: {
		local $TODO = "create_similar trouble";
		isa_ok ($surf, 'Cairo::ImageSurface');
	}
	isa_ok ($surf, 'Cairo::Surface');

	unlink 'tmp.ps';

	$surf = Cairo::PsSurface->create_for_stream (sub {
		my ($closure, $data) = @_;
		is ($closure, 'blub');
		like ($data, qr/PS/);
		die 'write-error';
	}, 'blub', IMG_WIDTH, IMG_HEIGHT);
	isa_ok ($surf, 'Cairo::PsSurface');
	isa_ok ($surf, 'Cairo::Surface');
}
