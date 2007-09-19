use Test::More tests => 6;
use Test::Exception;

use strict;
use warnings;

BEGIN { use_ok ('Exception::Simple') }

throws_ok { throw Exception::Simple error => 'Foo' } qr/Foo at t\/000_exception_simple\.t line \d+/;

throws_ok { throw Exception::Simple error => 'Foo',line => 42,package => 'Bar',filename => 'other.t' } qr/Foo at other\.t line 42/;

throws_ok { throw Exception::Simple error => 'Foo',only_error => 1 } qr/^Foo$/;

throws_ok { eval { throw Exception::Simple error => 'Foo' }; $@->rethrow } qr/Foo/;

{
  my $exception = Exception::Simple->new (error => 'Foo');

  is ($exception->stringify,"Foo\n");
}

