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
use ExtUtils::PkgConfig;
use ExtUtils::MakeMaker;

my %cairo_cfg = ExtUtils::PkgConfig->find ('cairo');
#print Dumper (\%cairo_cfg);

our %objects = (
	'cairo_t *' => 'Cairo',
	'cairo_surface_t *' => 'Cairo::Surface',
	'cairo_pattern_t *' => 'Cairo::Pattern',
	'cairo_matrix_t *' => 'Cairo::Matrix',
	'cairo_glyph_t *' => 'Cairo::Glyph',
	'cairo_font_t *' => 'Cairo::Font',
	'cairo_font_extents_t *' => 'Cairo::Font::Extents',
	'cairo_text_extents_t *' => 'Cairo::Text::Extents',
	'glitz_surface_t *' => 'Glitz::Surface',
);

our %enums = (
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

my %xs = map { /^(.*)\.xs$/; $_ => "$1.c"; } <*.xs>, do_enums ();
#print Dumper (\%xs);

my @typemaps = do_typemaps ();
push @typemaps, 'cairo-perl.typemap';

WriteMakefile (
	NAME => 'Cairo',
	VERSION_FROM => 'Cairo.pm',
	INC => '-I. '.$cairo_cfg{cflags},
	LIBS => $cairo_cfg{libs},
	XS => \%xs,
	OBJECT => q/$(O_FILES)/,
	XSPROTOARG => '-noprototypes',
	TYPEMAPS => \@typemaps,
);


package MY;
 
sub postamble
{
	"realclean ::
	-\$(RM_RF)  CairoEnums.xs cairo-perl-enums.h cairo-perl-auto.typemap";
}

package main;

sub do_typemaps
{
	my $cairo_perl = 'cairo-perl-auto.typemap';
	open TYPEMAP, '>'.$cairo_perl
		or die "unable to open ($cairo_perl) for output";

	print TYPEMAP "#\n#\n#\n\nTYPEMAP\n\n";

	sub type_id
	{
		my $ret = shift;
		$ret =~ s/ \*//;
		uc ($ret);
	}

	sub func_name
	{
		$_[0] =~ /cairo_(\w+)_t/;
		$1;
	}
	
	foreach (keys %objects, keys %enums)
	{
		print TYPEMAP $_."\t".type_id ($_)."\n";
	}

	print TYPEMAP "\nINPUT\n\n";

	foreach (keys %objects)
	{
		print TYPEMAP type_id ($_).'
	if (sv_derived_from($arg, \"'.$objects{$_}.'\")) {
	    IV tmp = SvIV((SV*)SvRV($arg));
	    $var = INT2PTR($type,tmp);
	}
	else
	    Perl_croak(aTHX_ \"$var is not of type '.$objects{$_}.'\")

';
	}

	foreach (keys %enums)
	{
		print TYPEMAP type_id ($_).'
	$var = cairo_'.func_name ($_).'_from_sv ($arg);

';
	}
	
	print TYPEMAP "\nOUTPUT\n\n";

	foreach (keys %objects)
	{
		print TYPEMAP type_id ($_).'
	sv_setref_pv($arg, \"'.$objects{$_}.'\", (void*)$var);

';
	}

	foreach (keys %enums)
	{
		print TYPEMAP type_id ($_).'
	$arg = cairo_'.func_name ($_).'_to_sv ($var);

';
	}

	close TYPEMAP;
	
	return ($cairo_perl);
}

sub do_enums
{
	my $cairo_enums = 'CairoEnums.xs';
	open ENUMS, '>'.$cairo_enums
		or die "unable to open ($cairo_enums) for output";

	sub name
	{
		$_[0] =~ /cairo_(\w+)_t/;
		$1;
	}

	print ENUMS "
/*
 *
 */

#include <cairo-perl.h>

";

	sub if_tree_from
	{
		my @enums = @_;

		my $prefix = shift @enums;

		my $full = shift @enums;
		my $name = $full;
		$name =~ s/$prefix//;
		my $len = length ($name);

		my $str = "	if (strncmp (str, \"$name\", $len) == 0)
		return $full;
";

		foreach $full (@enums)
		{
			$name = $full;
			$name =~ s/$prefix//;
			$len = length ($name);

			$str .= "	else if (strncmp (str, \"$name\", $len) == 0)
		return $full;
";
		}

		$str;
	}

	sub if_tree_to
	{
		my @enums = @_;

		my $prefix = shift @enums;
		my $full = shift @enums;

		my $str = "	if (val == $full)
		return newSVpv (\"$full\", 0);
";

		foreach $full (@enums)
		{
			$str .= "	else if (val = $full)
		return newSVpv (\"$full\", 0);
";
		}

		$str;
	}

	open HDR, ">cairo-perl-enums.h";
	print HDR "/*
 *
 */

#ifndef _CAIRO_PERL_ENUMS_H_
#define _CAIRO_PERL_ENUMS_H_
";

	foreach (keys %enums)
	{
		my $name = name ($_);

		print HDR "
int cairo_".$name."_from_sv (SV * $name);
SV * cairo_".$name."_to_sv (int val);
";
		
		print ENUMS 'int
cairo_'.$name.'_from_sv (SV * '.$name.')
{
	char * str = SvPV_nolen ('.$name.');

'.if_tree_from (@{$enums{$_}}).'
	croak ("bad value for '.$name.' (%s)\n", str);

	free (str);
	return 0;
}

SV *
cairo_'.$name.'_to_sv (int val)
{
'.if_tree_to (@{$enums{$_}}).'
	return newSVpv ("unknown/invalid", 0);
}

';
	}

	print HDR "
#endif /* _CAIRO_PERL_ENUMS_H_ */\n";
	close HDR;
	
	print ENUMS "MODULE = Cairo::Enums	PACKAGE = Cairo::Enums	PREFIX = cairo_enums_

";

	close ENUMS;
	return ($cairo_enums);
}
