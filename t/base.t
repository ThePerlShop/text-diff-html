#!/usr/bin/perl -w

# $Id: base.t 1930 2005-08-08 15:58:16Z theory $

use strict;
use Test::More tests => 1;

BEGIN { use_ok 'Text::Diff::HTML' or die; }
