#
# Copyright (c) 2004 by the cairo  perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#
# TODO:
#	- man this is horribly ulgy, stream-of-cons. even.
#

use strict;
use warnings;
use ExtUtils::PkgConfig;
use ExtUtils::MakeMaker;

use MakeHelper;

my $autogen_dir = 'build';
mkdir $autogen_dir unless (-d $autogen_dir);
$MakeHelper::autogen_dir = $autogen_dir;

my %cairo_cfg = ExtUtils::PkgConfig->find ('cairo');

my %objects = (
	'cairo_t *' => 'Cairo',
	'cairo_surface_t *' => 'Cairo::Surface',
	'cairo_pattern_t *' => 'Cairo::Pattern',
	'cairo_font_t *' => 'Cairo::Font',
);

my %structs = (
	'cairo_matrix_t *' => 'Cairo::Matrix',
	'cairo_glyph_t *' => 'Cairo::Glyph',
	'cairo_font_extents_t *' => 'Cairo::Font::Extents',
	'cairo_text_extents_t *' => 'Cairo::Text::Extents',
	'glitz_surface_t *' => 'Glitz::Surface',
);

my %enums = (
	cairo_format_t => [qw/
			CAIRO_FORMAT_
			CAIRO_FORMAT_ARGB32
			CAIRO_FORMAT_RGB24
			CAIRO_FORMAT_A8
			CAIRO_FORMAT_A1
	/],
	cairo_operator_t => [qw/
			CAIRO_OPERATOR_
			CAIRO_OPERATOR_CLEAR
			CAIRO_OPERATOR_SRC
			CAIRO_OPERATOR_DST
			CAIRO_OPERATOR_OVER
			CAIRO_OPERATOR_OVER_REVERSE
			CAIRO_OPERATOR_IN
			CAIRO_OPERATOR_IN_REVERSE
			CAIRO_OPERATOR_OUT
			CAIRO_OPERATOR_OUT_REVERSE
			CAIRO_OPERATOR_ATOP
			CAIRO_OPERATOR_ATOP_REVERSE
			CAIRO_OPERATOR_XOR
			CAIRO_OPERATOR_ADD
			CAIRO_OPERATOR_SATURATE
	/],
	cairo_fill_rule_t => [qw/
			CAIRO_FILL_RULE_
			CAIRO_FILL_RULE_WINDING
			CAIRO_FILL_RULE_EVEN_ODD
	/],
	cairo_line_cap_t => [qw/
			CAIRO_LINE_CAP_
			CAIRO_LINE_CAP_BUTT
			CAIRO_LINE_CAP_ROUND
			CAIRO_LINE_CAP_SQUARE
	/],
	cairo_line_join_t => [qw/
			CAIRO_LINE_JOIN_
			CAIRO_LINE_JOIN_MITER
			CAIRO_LINE_JOIN_ROUND
			CAIRO_LINE_JOIN_BEVEL
	/],
	cairo_font_slant_t => [qw/
			CAIRO_FONT_SLANT_
			CAIRO_FONT_SLANT_NORMAL
			CAIRO_FONT_SLANT_ITALIC
			CAIRO_FONT_SLANT_OBLIQUE
	/],
	cairo_font_weight_t => [qw/
			CAIRO_FONT_WEIGHT_
			CAIRO_FONT_WEIGHT_NORMAL
			CAIRO_FONT_WEIGHT_BOLD
	/],
	cairo_status_t => [qw/
			CAIRO_STATUS_
			CAIRO_STATUS_SUCCESS
			CAIRO_STATUS_NO_MEMORY
			CAIRO_STATUS_INVALID_RESTORE
			CAIRO_STATUS_INVALID_POP_GROUP
			CAIRO_STATUS_NO_CURRENT_POINT
			CAIRO_STATUS_INVALID_MATRIX
			CAIRO_STATUS_NO_TARGET_SURFACE
			CAIRO_STATUS_NULL_POINTER
	/],
	cairo_filter_t => [qw/
			CAIRO_FILTER_
			CAIRO_FILTER_FAST
			CAIRO_FILTER_GOOD
			CAIRO_FILTER_BEST
			CAIRO_FILTER_NEAREST
			CAIRO_FILTER_BILINEAR
			CAIRO_FILTER_GAUSSIAN
	/],
	cairo_extend_t => [qw/
			CAIRO_EXTEND_
			CAIRO_EXTEND_NONE
			CAIRO_EXTEND_REPEAT
			CAIRO_EXTEND_REFLECT
	/],
);

my @xs_files = <*.xs>;
my %xs = map { /^(.*)\.xs$/; $_ => "$1.c"; } @xs_files, 
		MakeHelper::do_enums (\%enums);

MakeHelper::write_boot (
	xs_files => \@xs_files,
	ignore => '(^Cairo$|Enums)',
);

my @typemaps = MakeHelper::do_typemaps (\%objects, \%structs, \%enums);
push @typemaps, 'cairo-perl.typemap';

my %pm = (
	'Cairo.pm' => '$(INST_LIBDIR)/Cairo.pm',
);

WriteMakefile (
	NAME => 'Cairo',
	VERSION_FROM => 'Cairo.pm',
	INC => '-I. -I'.$autogen_dir.' '.$cairo_cfg{cflags},
	LIBS => $cairo_cfg{libs},
	XS => \%xs,
	PM => \%pm,
	OBJECT => q/$(O_FILES)/,
	XSPROTOARG => '-noprototypes',
	TYPEMAPS => \@typemaps,
);


package MY;
 
sub postamble
{
	my $autogen_dir = $MakeHelper::autogen_dir;

	"realclean ::
	-\$(RM_RF) $autogen_dir CairoEnums.xs";
}

