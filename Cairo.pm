#
# Copyright (c) 2004 by the cairo  perl team (see the file README)
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

bootstrap Cairo $VERSION;

1;
