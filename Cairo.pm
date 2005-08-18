#
# Copyright (c) 2004-2005 by the cairo perl team (see the file README)
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

our $VERSION = '0.01';

Cairo->bootstrap ($VERSION);

# --------------------------------------------------------------------------- #

package Cairo::ImageSurface;

our @ISA = qw/Cairo::Surface/;

package Cairo::PdfSurface;

our @ISA = qw/Cairo::Surface/;

package Cairo::PsSurface;

our @ISA = qw/Cairo::Surface/;

# --------------------------------------------------------------------------- #

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

=head2 Cairo::Context

=over

=item Cairo::Context-E<gt>create

Creates a new I<Cairo::Context>.  In the following, I<$cr> will designate a
I<Cairo::Context>.

=item $cr-E<gt>save

=item ...

=back

=head2 Cairo::Font

=over

=item ...

=back

=head2 ...

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

Copyright (C) 2005 by the cairo perl team

=cut
