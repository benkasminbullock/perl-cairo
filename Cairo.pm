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

our $VERSION = '0.02';

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

1;
