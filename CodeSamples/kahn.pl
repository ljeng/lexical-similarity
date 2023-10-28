use Data::Dumper;

sub kahn {
  my ($graph, $n) = @_;
  my $inverse = {};
  for my $u (@$graph) {
    for my $v (@$graph->{$u}) {
      $inverse->{$v} //= [];
      push $inverse->{$v}, $u;
    }
  }

  my @stack = grep { !exists $inverse->{$_} }, (0 .. $n - 1);
  my @order = ();
  while (@stack) {
    my $u = pop @stack;
    push @order, $u;

    for my $v (@$graph->{$u}) {
      splice @$graph->{$u}, grep { $_ == $v }, 1;
      splice @$inverse->{$v}, grep { $_ == $u }, 1;
      if (!exists $inverse->{$v}) {
        push @stack, $v;
      }
    }
  }

  if (@order != $n) {
    return "Cyclic graph";
  }
  return @order;
}

open INPUT, "<input.txt";
open OUTPUT, ">output.txt";

my $n = <INPUT>;
my $graph = {};
while
