#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

use strict;
use warnings;
use ExtUtils::Depends;
use ExtUtils::PkgConfig;
use ExtUtils::MakeMaker;

use MakeHelper;

my $autogen_dir = 'build';
mkdir $autogen_dir unless (-d $autogen_dir);
$MakeHelper::autogen_dir = $autogen_dir;

our %prereqs = (
	'ExtUtils::Depends'   => 0.2,
	'ExtUtils::PkgConfig' => 1.0,
);

my %cairo_cfg = ExtUtils::PkgConfig->find ('cairo >= 1.0.0');

my %backend_macros = (
	'cairo_ps_surface_t' => 'CAIRO_HAS_PS_SURFACE',
	'cairo_pdf_surface_t' => 'CAIRO_HAS_PDF_SURFACE',
);

my %objects = (
	'cairo_t *' => 'Cairo::Context',
	'cairo_surface_t *' => 'Cairo::Surface',
	'cairo_image_surface_t *' => 'Cairo::ImageSurface',
	'cairo_pdf_surface_t *' => 'Cairo::PdfSurface',
	'cairo_ps_surface_t *' => 'Cairo::PsSurface',
	'cairo_pattern_t *' => 'Cairo::Pattern',
	'cairo_surface_pattern_t *' => 'Cairo::SurfacePattern',
	'cairo_gradient_t *' => 'Cairo::Gradient',
	'cairo_linear_gradient_t *' => 'Cairo::LinearGradient',
	'cairo_radial_gradient_t *' => 'Cairo::RadialGradient',
	'cairo_font_face_t *' => 'Cairo::FontFace',
	'cairo_scaled_font_t *' => 'Cairo::ScaledFont',
);

my %structs = (
	'cairo_matrix_t *' => 'Cairo::Matrix',
	'cairo_font_options_t *' => 'Cairo::FontOptions',
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
			CAIRO_OPERATOR_SOURCE
			CAIRO_OPERATOR_OVER
			CAIRO_OPERATOR_IN
			CAIRO_OPERATOR_OUT
			CAIRO_OPERATOR_ATOP
			CAIRO_OPERATOR_DEST
			CAIRO_OPERATOR_DEST_OVER
			CAIRO_OPERATOR_DEST_IN
			CAIRO_OPERATOR_DEST_OUT
			CAIRO_OPERATOR_DEST_ATOP
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
			CAIRO_STATUS_INVALID_STATUS
			CAIRO_STATUS_NULL_POINTER
			CAIRO_STATUS_INVALID_STRING
			CAIRO_STATUS_INVALID_PATH_DATA
			CAIRO_STATUS_READ_ERROR
			CAIRO_STATUS_WRITE_ERROR
			CAIRO_STATUS_SURFACE_FINISHED
			CAIRO_STATUS_SURFACE_TYPE_MISMATCH
			CAIRO_STATUS_PATTERN_TYPE_MISMATCH
			CAIRO_STATUS_INVALID_CONTENT
			CAIRO_STATUS_INVALID_FORMAT
			CAIRO_STATUS_INVALID_VISUAL
			CAIRO_STATUS_FILE_NOT_FOUND
			CAIRO_STATUS_INVALID_DASH
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
	cairo_path_data_type_t => [qw/
			CAIRO_PATH_
			CAIRO_PATH_MOVE_TO
			CAIRO_PATH_LINE_TO
			CAIRO_PATH_CURVE_TO
			CAIRO_PATH_CLOSE_PATH
	/],
	cairo_content_t => [qw/
			CAIRO_CONTENT_
			CAIRO_CONTENT_COLOR
			CAIRO_CONTENT_ALPHA
			CAIRO_CONTENT_COLOR_ALPHA
	/],
	cairo_antialias_t => [qw/
			CAIRO_ANTIALIAS_
			CAIRO_ANTIALIAS_DEFAULT
			CAIRO_ANTIALIAS_NONE
			CAIRO_ANTIALIAS_GRAY
			CAIRO_ANTIALIAS_SUBPIXEL
	/],
	cairo_subpixel_order_t => [qw/
			CAIRO_SUBPIXEL_ORDER_
			CAIRO_SUBPIXEL_ORDER_DEFAULT
			CAIRO_SUBPIXEL_ORDER_RGB
			CAIRO_SUBPIXEL_ORDER_BGR
			CAIRO_SUBPIXEL_ORDER_VRGB
			CAIRO_SUBPIXEL_ORDER_VBGR
	/],
	cairo_hint_style_t => [qw/
			CAIRO_HINT_STYLE_
			CAIRO_HINT_STYLE_DEFAULT
			CAIRO_HINT_STYLE_NONE
			CAIRO_HINT_STYLE_SLIGHT
			CAIRO_HINT_STYLE_MEDIUM
			CAIRO_HINT_STYLE_FULL
	/],
	cairo_hint_metrics_t => [qw/
			CAIRO_HINT_METRICS_
			CAIRO_HINT_METRICS_DEFAULT
			CAIRO_HINT_METRICS_OFF
			CAIRO_HINT_METRICS_ON
	/],
);

MakeHelper::do_enums (\%enums);

my @xs_files = <*.xs>;

MakeHelper::write_boot (
	xs_files => \@xs_files,
	ignore => '^Cairo$',
);

my @typemaps = MakeHelper::do_typemaps (\%objects, \%structs, \%enums,
                                        \%backend_macros);
push @typemaps, 'cairo-perl.typemap';

my $dep = ExtUtils::Depends->new ('Cairo');
$dep->set_inc ('-I. -I'.$autogen_dir.' '.$cairo_cfg{cflags});
$dep->set_libs ($cairo_cfg{libs});
$dep->add_xs (@xs_files);
$dep->add_c ('cairo-perl-enums.c');
$dep->add_pm ('Cairo.pm' => '$(INST_LIBDIR)/Cairo.pm');
$dep->add_typemaps (@typemaps);

$dep->install (qw(cairo-perl.h
                  cairo-perl.typemap
                  build/cairo-perl-enums.h
                  build/cairo-perl-auto.h
                  build/cairo-perl-auto.typemap));
$dep->save_config ('build/IFiles.pm');

WriteMakefile (
	NAME => 'Cairo',
	VERSION_FROM => 'Cairo.pm',
	ABSTRACT_FROM => 'Cairo.pm',
	PREREQ_PM => \%prereqs,
	XSPROTOARG => '-noprototypes',
	$dep->get_makefile_vars,
);

package MY;

sub postamble
{
	my $autogen_dir = $MakeHelper::autogen_dir;

	"realclean ::
	-\$(RM_RF) $autogen_dir cairo-perl-enums.c";
}
