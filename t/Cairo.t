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

use Test::More tests => 1;

use constant {
	IMG_WIDTH => 256,
	IMG_HEIGHT => 256,
};

BEGIN
{
	use_ok ('Cairo');
}

my $cr = Cairo->create;
#my $cp = $cr->copy;
#print Dumper ($cr);

#my $surf = Cairo::ImageSurface->create ('RGB24', 256, 128);
#print Dumper ($surf);
#$cr->set_target_surface ($surf);

my $png = 't/test.png';
END
{
	unlink ($png);
}

open OUT, ">$png" or die "unable to open $png for output";
$cr->set_target_png (*OUT, 'ARGB32', IMG_WIDTH, IMG_HEIGHT);

{
	$cr->save;
	$cr->scale (IMG_WIDTH / 1.0, IMG_HEIGHT / 1.0);
	$cr->rectangle (0, 0, 1.0, 1.0);
	$cr->set_rgb_color (1, 1, 1);
	$cr->fill;
	$cr->set_line_width (0.001);

	foreach (0..10)
	{
		$cr->set_rgb_color ($_ / 10, 0, 0);
		$cr->new_path;
		$cr->move_to (0.0, 0.0);
		$cr->line_to (1, 1);
		$cr->stroke;
		$cr->rotate (0.01);
	}

	$cr->restore;
}


#close OUT;
