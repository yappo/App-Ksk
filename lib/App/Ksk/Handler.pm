package App::Ksk::Handler;
use Any::Moose;

has 'ksk' => (
    is       => 'ro',
    isa      => 'App::Ksk',
    weak_ref => 1,
    required => 1,
);


no Any::Moose;

sub handler {
    my($self, $req) = @_;
    my $ksk = $self->ksk;
    $ksk->app->handler($ksk, $req);
}

__PACKAGE__->meta->make_immutable(inline_destructor => 1);

