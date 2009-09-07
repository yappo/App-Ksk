package App::Ksk;
use Any::Moose;
our $VERSION = '0.01';

has 'app' => (
    is       => 'ro',
    required => 1,
);

has 'psgi_setup' => (
    is       => 'ro',
    isa      => 'CodeRef',
    lazy     => 1,
    default  => sub {
        sub {
            my $handler = shift;
            require Plack::Impl::ServerSimple;
            my $psgi = Plack::Impl::ServerSimple->new(8081);
            $psgi->psgi_app($handler);
            $psgi->run;
        },
    },
    required => 1,
);

has 'run_finalizer' => (
    is       => 'ro',
    isa      => 'CodeRef',
    default  => sub { sub {} },
    required => 1,
);

has 'psgi_request_class' => (
    is       => 'ro',
    default  => 'Plack::Request',
    required => 1,
);

has 'psgi_response_class' => (
    is       => 'ro',
    default  => 'Plack::Response',
    required => 1,
);

has 'handler_class' => (
    is       => 'ro',
    default  => 'App::Ksk::Handler',
    required => 1,
);

has 'handler_obj' => (
    is      => 'rw',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        $self->handler_class->new({ ksk => $self });
    },
);

sub BUILD {
    my($self, ) = @_;
    my $class = $self->psgi_request_class;
    eval "require $class" or die $@;
    $class = $self->psgi_response_class;
    eval "require $class" or die $@;
    $class = $self->handler_class;
    eval "require $class" or die $@;
}

no Any::Moose;

sub run {
    my $self = shift;
    $self->psgi_setup->(sub { $self->handler(@_) });
    $self->run_finalizer->($self);
}

sub handler {
    my($self, $env) = @_;
    my $req = $self->psgi_request_class->new($env);
    my $res = $self->handler_obj->handler($req);
    my $psig_res = $res->finalize;
    $psig_res->[1] = [ %{ $psig_res->[1] } ] if ref($psig_res->[1]) eq 'HASH';
    $psig_res->[2] = [ $psig_res->[2] ] unless ref($psig_res->[2]);
    $psig_res;
}

__PACKAGE__->meta->make_immutable(inline_destructor => 1);
__END__

=encoding utf8

=head1 NAME

App::Ksk - simple PSGI application launcher

=head1 SYNOPSIS

example

  $ script/ksk.pl ./examples/sample.pl

=head1 DESCRIPTION

App::Ksk is

=head1 AUTHOR

Kazuhiro Osawa E<lt>yappo <at> shibuya <döt> plE<gt>

=head1 SEE ALSO

=head1 REPOSITORY

  svn co http://svn.coderepos.org/share/lang/perl/App-Ksk/trunk App-Ksk

App::Ksk is Subversion repository is hosted at L<http://coderepos.org/share/>.
patches and collaborators are welcome.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
