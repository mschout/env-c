package Env::C;

require 5.005;

use strict;
#use warnings;

require DynaLoader;
@Env::C::ISA = qw(DynaLoader);
$Env::C::VERSION = '0.07';

bootstrap Env::C $Env::C::VERSION;

1;
__END__

=head1 NAME

Env::C - Get/Set/Unset Environment Variables on the C level



=head1 SYNOPSIS

  use Env::C;
  
  my $key = "USER";
  $val = Env::C::getenv($key) || '';
  
  Env::C::setenv($key, "foobar", [$override]);
  $new_val = Env::C::getenv($key) || '';
  
  Env::C::unsetenv($key);
  
  my $ar_env = Env::C::getallenv();
  print join "\n", @$ar_env;



=head1 DESCRIPTION

This module provides a Perl API for getenv(3), setenv(3) and
unsetenv(3). It also can return all the C<environ> variables.

Sometimes Perl invokes modules with underlaying C APIs which rely on
certain environment variables to be set, if these variables are set in
Perl and the glue code doesn't worry to set them on the C level, these
variables might not be seen by the C level. This module shows what
really the C level sees.




=head2 FUNCTIONS

=over

=item * getenv()

  $val = Env::C::getenv($key);

Returns the value of the environment variable matching the key or
C<undef>.

=item * setenv()

  Env::C::setenv($key, $value, [$override]);

The setenv() function adds the variable C<$key> to the environment
with the value C<$value>, if C<$key> does not already exist.  If
C<$key> does exist in the environment, then its value is changed to
C<$value> if C<$override> is non-zero; if C<$override> is zero or is
not passed, then the value of C<$key> is not changed.

=item * unsetenv()

  Env::C::unsetenv($key);

The unsetenv() function deletes the variable C<$key> from the
environment.

=item * getallenv()

  my $ar_env = Env::C::getallenv();
  print join "\n", @$ar_env;

The getallenv() function returns an array reference which includes all
the environment variables.

=back




=head2 EXPORT

None.




=head1 Thread-safety and Thread-locality

This module should not be used in the threaded enviroment.

Thread-locality: the OS, which maintains the struct C<environ>, shares
it between all threads in the process. So if you modify it in one
thread, all other threads will see the new value. Something that will
most likely break the code.

This module is not thread-safe, since two threads may attempt to
modify/read the struct C<environ> at the same time. I could add
locking if in threaded-environment. However since the lock can't be
seen by other applications, they can still bypass it causing race
condition. But since thread-locality is not maintained, making this
module thread-safe is useless.

If you need to modify the C level of C<%ENV> for all threads to see,
do that before threads are started. (e.g. for mod_perl 2.0, at the
server startup).




=head1 AUTHOR

Stas Bekman E<lt>stas@stason.orgE<gt>



=head1 COPYRIGHT

This is a free software; you can redistribute it and/or modify it
under the terms of the Artistic License.



=head1 SEE ALSO

L<perl>.

=cut
