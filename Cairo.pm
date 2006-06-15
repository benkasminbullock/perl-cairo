#
# Copyright (c) 2004-2006 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header$
#

package Cairo;

use strict;
use warnings;
use DynaLoader;

our @ISA = qw/DynaLoader/;

our $VERSION = '0.04';

sub dl_load_flags { $^O eq 'darwin' ? 0x00 : 0x01 }

Cairo->bootstrap ($VERSION);

# --------------------------------------------------------------------------- #

package Cairo::ImageSurface;

our @ISA = qw/Cairo::Surface/;

package Cairo::PdfSurface;

our @ISA = qw/Cairo::Surface/;

package Cairo::PsSurface;

our @ISA = qw/Cairo::Surface/;

# --------------------------------------------------------------------------- #

package Cairo::SolidPattern;

our @ISA = qw/Cairo::Pattern/;

package Cairo::SurfacePattern;

our @ISA = qw/Cairo::Pattern/;

package Cairo::Gradient;

our @ISA = qw/Cairo::Pattern/;

package Cairo::LinearGradient;

our @ISA = qw/Cairo::Gradient/;

package Cairo::RadialGradient;

our @ISA = qw/Cairo::Gradient/;

# --------------------------------------------------------------------------- #

package Cairo;

1;

__END__

=head1 NAME

Cairo - Perl interface to the cairo library

=head1 SYNOPSIS

  use Cairo;

  my $surface = Cairo::ImageSurface->create ('argb32', 100, 100);
  my $cr = Cairo::Context->create ($surface);

  $cr->rectangle (10, 10, 40, 40);
  $cr->set_source_rgb (0, 0, 0);
  $cr->fill;

  $cr->rectangle (50, 50, 40, 40);
  $cr->set_source_rgb (1, 1, 1);
  $cr->fill;

  $cr->show_page;

  $surface->write_to_png ("output.png");

=head1 ABSTRACT

Cairo provides Perl bindings for the vector graphics library cairo.  It
supports multiple output targets, including the X Window Systems, PDF, and PNG.
Cairo produces identical output on all those targets and makes use of hardware
acceleration wherever possible.

=head1 API DOCUMENTATION

=head2 Cairo::Context -- The cairo drawing context

I<Cairo::Context> is the main object used when drawing with Cairo. To draw with
Cairo, you create a I<Cairo::Context>, set the target surface, and drawing
options for the I<Cairo::Context>, create shapes with methods like
C<$cr->move_to> and C<$cr-E<gt>line_to>, and then draw shapes with
C<$cr-E<gt>stroke> or C<$cr-E<gt>fill>.

I<Cairo::Context>'s can be pushed to a stack via C<$cr-E<gt>save>. They may
then safely be changed, without loosing the current state. Use
C<$cr-E<gt>restore> to restore to the saved state.

=over

=item $cr = Cairo::Context-E<gt>create ($surface)

=over

=item $surface: I<Cairo::Surface>

=back

=item $cr-E<gt>save

=item $cr->restore

=item $status = $cr->status

=item $surface = $cr->get_target

=item $surface = $cr->get_group_target

=item $cr->set_source_rgb ($red, $green, $blue)

=over

=item $red: double

=item $green: double

=item $blue: double

=back

=item $cr->set_source_rgba ($red, $green, $blue, $alpha)

=over

=item $red: double

=item $green: double

=item $blue: double

=item $alpha: double

=back

=item $cr->set_source ($source)

=over

=item $source: I<Cairo::Pattern>

=back

=item $cr->set_source_surface ($surface, $x, $y)

=over

=item $surface: I<Cairo::Surface>

=item $x: double

=item $y: double

=back

=item $source = $cr->get_source ()

=item $cr->set_antialias ($antialias)

=over

=item $antialias: I<Cairo::Antialias>

=back

=item $antialias = $cr->get_antialias

=item $cr->set_dash ($offset, ...)

=over

=item $offset: double

=item ...: list of doubles

=back

=item $cr->set_fill_rule ($fill_rule)

=over

=item $fill_rule: I<Cairo::FillRule>

=back

=item $cr->fill_rule_t $cr->get_fill_rule

=item $cr->set_line_cap ($line_cap)

=over

=item $line_cap: I<Cairo::LineCap>

=back

=item $line_cap = $cr->get_line_cap

=item $cr->set_line_join ($line_join)

=over

=item $line_join: I<Cairo::LineJoin>

=back

=item $line_join = $cr->get_line_join

=item $cr->set_line_width ($width)

=over

=item $width: double

=back

=item $width = $cr->get_line_width

=item $cr->set_miter_limit ($ limit)

=over

=item $limit: double

=back

=item $limit = $cr->get_miter_limit

=item $cr->set_operator ($op)

=over

=item $op: I<Cairo::Operator>

=back

=item $op = $cr->get_operator

=item $cr->set_tolerance ($tolerance)

=over

=item $tolerance: double

=back

=item $tolerance = $cr->get_tolerance

=item $cr->clip

=item $cr->clip_preserve

=item $cr->reset_clip

=item $cr->fill

=item $cr->fill_preserve

=item ($x1, $y1, $x2, $y2) = $cr->fill_extents

=item $bool = $cr->in_fill ($x, $y)

=over

=item $x: double

=item $y: double

=back

=item $cr->mask ($pattern)

=over

=item $pattern: I<Cairo::Pattern>

=back

=item $cr->mask_surface ($surface, $surface_x, $surface_y)

=over

=item $surface: I<Cairo::Surface>

=item $surface_x: double

=item $surface_y: double

=back

=item $cr->paint

=item $cr->paint_with_alpha ($alpha)

=over

=item $alpha: double

=back

=item $cr->stroke

=item $cr->stroke_preserve

=item ($x1, $y1, $x2, $y2) = $cr->stroke_extents

=item $bool = $cr->in_stroke ($x, $y)

=over

=item $x: double

=item $y: double

=back

=item $cr->copy_page

=item $cr->show_page

=back

=cut

# --------------------------------------------------------------------------- #

=head2 Paths -- Creating paths and manipulating path data

  $path = [
    { type => "move-to", points => [[1, 2]] },
    { type => "line-to", points => [[3, 4]] },
    { type => "curve-to", points => [[5, 6], [7, 8], [9, 10]] },
    ...
    { type => "close-path", points => [] },
  ];

I<Cairo::Path> is a data structure for holding a path. This data structure
serves as the return value for C<$cr-E<gt>copy_path_data> and
C<$cr-E<gt>copy_path_data_flat> as well the input value for
C<$cr-E<gt>append_path>.

I<Cairo::Path> is represented as an array reference that contains path
elements, represented by hash references with two keys: I<type> and I<points>.
The value for I<type> can be either of the following:

=over

=item C<move-to>

=item C<line-to>

=item C<curve-to>

=item C<close-path>

=back

The value for I<points> is an array reference which contains zero or more
points.  Points are represented as array references that contain two doubles:
I<x> and I<y>.  The necessary number of points depends on the I<type> of the
path element:

=over

=item C<move-to>: 1 point

=item C<line_to>: 1 point

=item C<curve-to>: 3 points

=item C<close-path>: 0 points

=back

The semantics and ordering of the coordinate values are consistent with
C<$cr-E<gt>move_to>, C<$cr-E<gt>line_to>, C<$cr-E<gt>curve_to>, and
C<$cr-E<gt>close_path>.

=over

=item $path = $cr->copy_path

=item $path = $cr->copy_path_flat

=item $cr->append_path ($path)

=over

=item $path: I<Cairo::Path>

=back

=item ($x, $y) = $cr->get_current_point

=item $cr->new_path

=item $cr->new_sub_path

=item $cr->close_path

=item $cr->arc ($xc, $yc, $radius, $angle1, $angle2)

=over

=item $xc: double

=item $yc: double

=item $radius: double

=item $angle1: double

=item $angle2: double

=back

=item $cr->arc_negative ($xc, $yc, $radius, $angle1, $angle2)

=over

=item $xc: double

=item $yc: double

=item $radius: double

=item $angle1: double

=item $angle2: double

=back

=item $cr->curve_to ($x1, $y1, $x2, $y2, $x3, $y3)

=over

=item $x1: double

=item $y1: double

=item $x2: double

=item $y2: double

=item $x3: double

=item $y3: double

=back

=item $cr->line_to ($x, $y)

=over

=item $x: double

=item $y: double

=back

=item $cr->move_to ($x, $y)

=over

=item $x: double

=item $y: double

=back

=item $cr->rectangle ($x, $y, $width, $height)

=over

=item $x: double

=item $y: double

=item $width: double

=item $height: double

=back

=item $cr->glyph_path (...)

=over

=item ...: list of I<Cairo::Glyph>'s

=back

=item $cr->text_path ($utf8)

=over

=item $utf8: string in utf8 encoding

=back

=item $cr->rel_curve_to ($dx1, $dy1, $dx2, $dy2, $dx3, $dy3)

=over

=item $dx1: double

=item $dy1: double

=item $dx2: double

=item $dy2: double

=item $dx3: double

=item $dy3: double

=back

=item $cr->rel_line_to ($dx, $dy)

=over

=item $dx: double

=item $dy: double

=back

=item $cr->rel_move_to ($dx, $dy)

=over

=item $dx: double

=item $dy: double

=back

=back

=cut

# --------------------------------------------------------------------------- #

=head2 Patterns -- Gradients and filtered sources

=over

=item $status = $pattern->status

=item $type = $pattern->get_type

=item $pattern->set_matrix ($matrix)

=over

=item $matrix: I<Cairo::Matrix>

=back

=item $matrix = $pattern->get_matrix

=item $pattern = Cairo::SolidPattern->create_rgb ($red, $green, $blue)

=over

=item $red: double

=item $green: double

=item $blue: double

=back

=item $pattern = Cairo::SolidPattern->create_rgba ($red, $green, $blue, $alpha)

=over

=item $red: double

=item $green: double

=item $blue: double

=item $alpha: double

=back

=item $matrix = $pattern->get_matrix

=item $pattern = Cairo::SurfacePattern->create ($surface)

=over

=item $surface: I<Cairo::Surface>

=back

=item $pattern->set_extend ($extend)

=over

=item $extend: I<Cairo::Extend>

=back

=item $extend = $pattern->get_extend

=item $pattern->set_filter ($filter)

=over

=item $filter: I<Cairo::Filter>

=back

=item $filter = $pattern->get_filter

=item $pattern = Cairo::LinearGradient->create ($x0, $y0, $x1, $y1)

=over

=item $x0: double

=item $y0: double

=item $x1: double

=item $y1: double

=back

=item $pattern = Cairo::RadialGradient->create ($cx0, $cy0, $radius0, $cx1, $cy1, $radius1)

=over

=item $cx0: double

=item $cy0: double

=item $radius0: double

=item $cx1: double

=item $cy1: double

=item $radius1: double

=back

=item $pattern->add_color_stop_rgb (double offset, double red, double green, double blue)

=over

=item $offset: double

=item $red: double

=item $green: double

=item $blue: double

=back

=item $pattern->add_color_stop_rgba (double offset, double red, double green, double blue, double alpha)

=over

=item $offset: double

=item $red: double

=item $green: double

=item $blue: double

=item $alpha: double

=back

=back

=cut

# --------------------------------------------------------------------------- #

=head2 Transformations -- Manipulating the current transformation matrix

=over

=item $cr->translate ($tx, $ty)

=over

=item $tx: double

=item $ty: double

=back

=item $cr->scale ($sx, $sy)

=over

=item $sx: double

=item $sy: double

=back

=item $cr->rotate ($angle)

=over

=item $angle: double

=back

=item $cr->transform ($matrix)

=over

=item $matrix: I<Cairo::Matrix>

=back

=item $cr->set_matrix ($matrix)

=over

=item $matrix: I<Cairo::Matrix>

=back

=item $matrix = $cr->get_matrix

=item $cr->identity_matrix

=item ($x, $y) = $cr->user_to_device ($x, $y)

=over

=item $x: double

=item $y: double

=back

=item ($dx, $dy) = $cr->user_to_device_distance ($dx, $dy)

=over

=item $dx: double

=item $dy: double

=back

=item ($x, $y) = $cr->device_to_user ($x, $y)

=over

=item $x: double

=item $y: double

=back

=item ($dx, $dy) = $cr->device_to_user_distance ($dx, $dy)

=over

=item $dx: double

=item $dy: double

=back

=back

=cut

# --------------------------------------------------------------------------- #

=head2 Text -- Rendering text and sets of glyphs

Glyphs are represented as anonymous hash references with three keys: I<index>,
I<x> and I<y>.  Example:

  my @glyphs = ({ index => 1, x => 2, y => 3 },
                { index => 2, x => 3, y => 4 },
                { index => 3, x => 4, y => 5 });

=over

=item $cr->select_font_face ($family, $slant, $weight)

=over

=item $family: string

=item $slant: I<Cairo::FontSlant>

=item $weight: I<Cairo::FontWeight>

=back

=item $cr->set_font_size ($size)

=over

=item $size: double

=back

=item $cr->set_font_matrix ($matrix)

=over

=item $matrix: I<Cairo::Matrix>

=back

=item $matrix = $cr->get_font_matrix

=item $cr->set_font_options ($options)

=over

=item $options: I<Cairo::FontOptions>

=back

=item $options = $cr->get_font_options

=item $cr->set_scaled_font ($scaled_font)

=over

=item $scaled_font: I<Cairo::ScaledFont>

=back

=item $cr->show_text ($utf8)

=over

=item $utf8: string

=back

=item $cr->show_glyphs (...)

=over

=item ...: list of glyphs

=back

=item $face = $cr->get_font_face

=item $extents = $cr->font_extents

=item $cr->set_font_face ($font_face)

=over

=item $font_face: I<Cairo::FontFace>

=back

=item $extents = $cr->text_extents ($utf8)

=over

=item $utf8: string

=back

=item $extents = $cr->glyph_extents (...)

=over

=item ...: list of glyphs

=back

=back

=cut

# --------------------------------------------------------------------------- #

=head2 Version Information -- Run-time version checks.

=over

=item $version = Cairo->version

=item $string = Cairo->version_string

=back

=cut

# --------------------------------------------------------------------------- #

=head1 SEE ALSO

=over

=item http://cairographics.org/documentation

Lists many available resources including tutorials and examples

=item http://cairographics.org/manual/

Contains the reference manual

=back

=head1 AUTHORS

=over

=item Ross McFarland E<lt>rwmcfa1 at neces dot comE<gt>

=item Torsten Schoenfeld E<lt>kaffeetisch at gmx dot deE<gt>

=back

=head1 COPYRIGHT

Copyright (C) 2004-2006 by the cairo perl team

=cut
