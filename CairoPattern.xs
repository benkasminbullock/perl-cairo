/*
 * Copyright (c) 2004 by the cairo  perl team (see the file README)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include <cairo-perl.h>

MODULE = Cairo::Pattern	PACKAGE = Cairo::Pattern PREFIX = cairo_pattern_

cairo_pattern_t * cairo_pattern_create_for_surface (cairo_surface_t * surface);

cairo_pattern_t * cairo_pattern_create_linear (double x0, double y0, double x1, double y1);

cairo_pattern_t * cairo_pattern_create_radial (double cx0, double cy0, double radius0, double cx1, double cy1, double radius1);

void cairo_pattern_reference (cairo_pattern_t * pattern);

void cairo_pattern_destroy (cairo_pattern_t * pattern);
  
cairo_status_t cairo_pattern_add_color_stop (cairo_pattern_t * pattern, double offset, double red, double green, double blue, double alpha);
  
cairo_status_t cairo_pattern_set_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);

cairo_status_t cairo_pattern_get_matrix (cairo_pattern_t * pattern, cairo_matrix_t * matrix);

cairo_status_t cairo_pattern_set_extend (cairo_pattern_t * pattern, cairo_extend_t extend);

cairo_extend_t cairo_pattern_get_extend (cairo_pattern_t * pattern);

cairo_status_t cairo_pattern_set_filter (cairo_pattern_t * pattern, cairo_filter_t filter);

cairo_filter_t cairo_pattern_get_filter (cairo_pattern_t * pattern);

