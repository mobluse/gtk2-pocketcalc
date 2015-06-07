#!/usr/bin/perl
# pocketcalc.pl - A pocket calculator for GTK2
# Author: Mikael O. Bonnier <mikael.bonnier@gmail.com>
# License: GPLv3+

use strict;
use Glib qw/TRUE FALSE/;
use Gtk2 -init;
use utf8;

my $window = Gtk2::Window->new('toplevel');
$window->signal_connect('delete-event'=> sub {Gtk2->main_quit()});
$window->set_title('PocketCalc');
$window->set_border_width(5);
$window->set_position('center-always');

my $display;

&fill_window($window);

$window->show_all();

Gtk2->main();

sub fill_window {
  my ($win) = @_;

  my $table = Gtk2::Table->new(7, 5, FALSE);
  
  my $btn_x = Gtk2::Button->new('X');
  $btn_x->signal_connect('button-release-event' => \&rec_x);
  $table->attach_defaults ($btn_x, 0, 1, 0, 1);

  $display = Gtk2::Entry->new();
  $display->set_text('0');
  $display->signal_connect(changed => sub {
    my $text = $display->get_text;
  });
  $table->attach_defaults($display, 1, 6, 0, 1);

  my $btn_ms = Gtk2::Button->new('MS');
  $btn_ms->signal_connect('button-release-event' => \&rec_ms);
  $table->attach_defaults ($btn_ms, 6, 7, 0, 1);

  my $btn_neg = Gtk2::Button->new('±');
  $btn_neg->signal_connect('button-release-event' => \&rec_neg);
  $table->attach_defaults ($btn_neg, 0, 1, 1, 2);

  my $btn_7 = Gtk2::Button->new('7');
  $btn_7->signal_connect('button-release-event' => \&rec_7);
  $table->attach_defaults ($btn_7, 1, 2, 1, 2);

  my $btn_8 = Gtk2::Button->new('8');
  $btn_8->signal_connect('button-release-event' => \&rec_8);
  $table->attach_defaults ($btn_8, 2, 3, 1, 2);

  my $btn_9 = Gtk2::Button->new('9');
  $btn_9->signal_connect('button-release-event' => \&rec_9);
  $table->attach_defaults ($btn_9, 3, 4, 1, 2);

  my $btn_pct = Gtk2::Button->new('%');
  $btn_pct->signal_connect('button-release-event' => \&rec_pct);
  $table->attach_defaults ($btn_pct, 4, 5, 1, 2);

  my $btn_q = Gtk2::Button->new('?');
  $btn_q->signal_connect('button-release-event' => \&rec_q);
  $table->attach_defaults ($btn_q, 5, 6, 1, 2);

  my $btn_mc = Gtk2::Button->new('MC');
  $btn_mc->signal_connect('button-release-event' => \&rec_mc);
  $table->attach_defaults ($btn_mc, 6, 7, 1, 2);

  my $btn_sqrt = Gtk2::Button->new('√');
  $btn_sqrt->signal_connect('button-release-event' => \&rec_sqrt);
  $table->attach_defaults ($btn_sqrt, 0, 1, 2, 3);

  my $btn_4 = Gtk2::Button->new('4');
  $btn_4->signal_connect('button-release-event' => \&rec_4);
  $table->attach_defaults ($btn_4, 1, 2, 2, 3);

  my $btn_5 = Gtk2::Button->new('5');
  $btn_5->signal_connect('button-release-event' => \&rec_5);
  $table->attach_defaults ($btn_5, 2, 3, 2, 3);

  my $btn_6 = Gtk2::Button->new('6');
  $btn_6->signal_connect('button-release-event' => \&rec_6);
  $table->attach_defaults ($btn_6, 3, 4, 2, 3);

  my $btn_mul = Gtk2::Button->new('×');
  $btn_mul->signal_connect('button-release-event' => \&rec_mul);
  $table->attach_defaults ($btn_mul, 4, 5, 2, 3);

  my $btn_div = Gtk2::Button->new('÷');
  $btn_div->signal_connect('button-release-event' => \&rec_div);
  $table->attach_defaults ($btn_div, 5, 6, 2, 3);

  my $btn_mr = Gtk2::Button->new('MR');
  $btn_mr->signal_connect('button-release-event' => \&rec_mr);
  $table->attach_defaults ($btn_mr, 6, 7, 2, 3);

  my $btn_c = Gtk2::Button->new('C');
  $btn_c->signal_connect('button-release-event' => \&rec_c);
  $table->attach_defaults ($btn_c, 0, 1, 3, 4);

  my $btn_1 = Gtk2::Button->new('1');
  $btn_1->signal_connect('button-release-event' => \&rec_1);
  $table->attach_defaults ($btn_1, 1, 2, 3, 4);

  my $btn_2 = Gtk2::Button->new('2');
  $btn_2->signal_connect('button-release-event' => \&rec_2);
  $table->attach_defaults ($btn_2, 2, 3, 3, 4);

  my $btn_3 = Gtk2::Button->new('3');
  $btn_3->signal_connect('button-release-event' => \&rec_3);
  $table->attach_defaults ($btn_3, 3, 4, 3, 4);

  my $btn_add = Gtk2::Button->new('+');
  $btn_add->signal_connect('button-release-event' => \&rec_add);
  $table->attach_defaults ($btn_add, 4, 5, 3, 5);

  my $btn_sub = Gtk2::Button->new('-');
  $btn_sub->signal_connect('button-release-event' => \&rec_sub);
  $table->attach_defaults ($btn_sub, 5, 6, 3, 4);

  my $btn_m_sub = Gtk2::Button->new('M-');
  $btn_m_sub->signal_connect('button-release-event' => \&rec_m_sub);
  $table->attach_defaults ($btn_m_sub, 6, 7, 3, 4);

  my $btn_ac = Gtk2::Button->new('AC');
  $btn_ac->signal_connect('button-release-event' => \&rec_ac);
  $table->attach_defaults ($btn_ac, 0, 1, 4, 5);

  my $btn_0 = Gtk2::Button->new('0');
  $btn_0->signal_connect('button-release-event' => \&rec_0);
  $table->attach_defaults ($btn_0, 1, 3, 4, 5);

  my $btn_pt = Gtk2::Button->new('.');
  $btn_pt->signal_connect('button-release-event' => \&rec_pt);
  $table->attach_defaults ($btn_pt, 3, 4, 4, 5);

  my $btn_eq = Gtk2::Button->new('=');
  $btn_eq->signal_connect('button-release-event' => \&rec_eq);
  $table->attach_defaults ($btn_eq, 5, 6, 4, 5);

  my $btn_m_add = Gtk2::Button->new('M+');
  $btn_m_add->signal_connect('button-release-event' => \&rec_m_add);
  $table->attach_defaults ($btn_m_add, 6, 7, 4, 5);

  $win->add($table);
  return $win;
}

sub rec_x {

}

sub rec_ms {

}

sub rec_neg {

}

sub rec_7 {
  append('7');
}

sub rec_8 {
#  my ($widget,$event) = @_;
  append('8');
}

sub rec_9 {
  append('9');
}

sub rec_pct {

}

sub rec_q {

}

sub rec_mc {

}

sub rec_sqrt {

}

sub rec_4 {
  append('4');
}

sub rec_5 {
  append('5');
}

sub rec_6 {
  append('6');
}

sub rec_mul {

}

sub rec_div {

}

sub rec_mr {

}

sub rec_c {
  $display->set_text('0');
}

sub rec_1 {
  append('1');
}

sub rec_2 {
  append('2');
}

sub rec_3 {
  append('3');
}

sub rec_add {

}

sub rec_sub {

}

sub rec_m_sub {

}

sub rec_ac {
  $display->set_text('0');
}

sub rec_0 {
  append('0');
}

sub rec_pt {

}

sub rec_eq {

}

sub rec_m_add {

}

sub append {
  my ($number) = @_;
  $display->set_text($display->get_text . $number);
}
