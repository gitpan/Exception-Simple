#!/usr/bin/env perl

use inc::Module::Install;

use strict;
use warnings;

name           'Exception-Simple';
all_from       'lib/Exception/Simple.pm';

requires       'Moose' => '0.22';

build_requires 'Test::More' => '0.47';
build_requires 'Test::Exception' => '0.21';

auto_install;
WriteAll;

