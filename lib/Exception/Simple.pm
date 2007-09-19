package Exception::Simple;

use Moose;

use overload '""' => \&_as_string;

has 'error'      => (is => 'rw',isa => 'Str',required => 1);
has 'only_error' => (is => 'rw',isa => 'Bool',default => 0);
has 'package'    => (is => 'rw',isa => 'Str',predicate => 'has_package');
has 'filename'   => (is => 'rw',isa => 'Str',predicate => 'has_filename');
has 'line'       => (is => 'rw',isa => 'Int',predicate => 'has_line');

our $VERSION = '0.0099_01';

our $AUTHORITY = 'cpan:BERLE';

sub throw {
  my ($class,%arguments) = @_;

  my ($package,$filename,$line) = caller;

  $arguments{package} ||= $package;

  $arguments{filename} ||= $filename;

  $arguments{line} ||= $line;

  my $self = $class->new (%arguments);

  die $self;
}

sub rethrow {
  my ($self,%arguments) = @_;

  die $self;
}

sub _as_string {
  my ($self) = @_;

  return $self->stringify;
}

sub stringify {
  my ($self) = @_;

  my $string = $self->error;

  unless ($self->only_error) {
    $string .= ' at ' . $self->filename
      if $self->has_filename;

    $string .= ' line ' . $self->line
      if $self->has_line;

    $string .= "\n";
  }

  return $string;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Exception::Simple - Exception classes and nothing more.

=head1 SYNOPSIS

  use Exception::Simple;
  use Scalar::Util qw/blessed/;

  eval {
    throw Exception::Simple error => "Oh noes";
  };

  if (blessed $@ && $@->isa ('Exception::Simple')) {
    # Do something.
  }

=head1 DESCRIPTION

Why another exception class? Well, as I was looking around CPAN for an
exception class for my project, I found a lot of exception classes and
none that suited my need; A simple exception class that didn't have
any elaborate try/catch syntax, was easy to work with after exceptions
were thrown, etc.

This module aims to do nothing but being an exception class. No sugar,
no utility modules, just an exception class that should be flexible
and easy to extend.

=head1 ATTRIBUTES

The module has a number of attributes that may be specified or even
fills in automagically depending on how the exception is created. In
addition to setting them as arguments to new/throw/rethrow, they may
also be both retrieved and set through accessors. All optional
attributes has a special has_attributename method that can be used to
determine if they are set or not.

=over 4

=item error (mandatory)

A mandatory description of the error being thrown.

=item package (optional, automagic)

Which package the exception was thrown in. Will be filled in
automagically if not specified. This is currently not used for
generating the error message but caller provides this so we store it.

=item filename (optional, automagic)

Which filename the code we throw in belongs to. Will as with package
be filled in automagically if nothing is provided.

=item line (optional, automagic)

Which line we threw the exception at. Also automagic.

=back

=head1 METHODS

=over 4

=item throw

Throws an exception. It will collect information about the caller and
fill in the attributes with this unless they are provided by the user.
Then the exception object is created 

=item rethrow

Rethrow throws an existing object. It will unlike throw not attempt to
collect any information about the caller even if none currently is
set.

=item new

Simply creates the object. Does not collect any information about the
environment, nor does it cause the exception to be thrown.

=item stringify

Generates a string representation of the exception, similar to an
ordinary die() message. The stringification overload calls this method
to generate an error, so override this if you want to change that.

=back

=head1 CAVEATS

My philosophy is that once an exception is thrown, you're no longer
interested in performance as top priority. This module uses L<Moose>
beneath the hood, which is a slightly heavy module. This may change in
the future, but will in any case not affect you when no exceptions are
thrown.

=head1 SEE ALSO

=over 4

=item L<Exception::Class>

=item L<Moose>

=back

=head1 BUGS

Most software has bugs. This module probably isn't an exception. 
If you find a bug please either email me, or add the bug to cpan-RT.

=head1 AUTHOR

Anders Nor Berle E<lt>debolaz@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Anders Nor Berle.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

