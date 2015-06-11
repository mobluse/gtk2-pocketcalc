#!/usr/bin/perl
# pocketcalc.pl - An unfinished pocket calculator for Gtk2
# Author: Mikael O. Bonnier <mikael.bonnier@gmail.com>
# License: GPLv3+
# Install on Linux: sudo apt-get install libgtk2-perl
# Run: perl pocketcalc.pl (or ./pocketcalc.pl)
# See: http://gtk2-perl.sourceforge.net/doc/gtk2-perl-study-guide/
#      http://foobaring.blogspot.se/2013/03/howto-install-gtk2-in-activeperl-in.html
#      JSON-file from https://scratch.mit.edu/projects/13110194/

use strict;
use warnings;
use utf8;
use POSIX;
use Glib qw/TRUE FALSE/;
use Gtk2 -init;

my $Program;
my $b_Event;
my $_paused;
my $ZERO;
my $Delay;
my $Display;
my $_op;
my $_b_new_number;
my $_b_decimal;
my $_reg;
my $_memory_idx;
my @_memories;
my $_memory_temp;
my $_b_constant;
my $_constant;
my $_op_constant;
my $_b_percent;
my $_first;
my $_b_function;
my $_command;
my $_condition;
my $_b_decimal_extra;
my $_b_eq_op;
my $_b_found;
my $_i;
my $_name;
my $_op_arg;
my $_op_new;
my $_pc;
my $_temp;
my $_value;
my @_return_stack;

init();
init_win();

sub init {
  $b_Event = 0;
  $_paused = 0;
  $ZERO = 0.0000000000000009;
  $Delay = 0.2;
  $_op = '';
  $_b_new_number = 1;
  $_b_decimal = 0;
  $_reg = 0;
  $_memory_idx = 1;
  $_memories[0] = 0;
  $_memories[1] = 0;
  $_memory_temp = 0;
  $_b_constant = 0;
  $_constant = 0;
  $_op_constant = '';
  $_b_percent = 0;
  $_first = 0;
  $_b_function = 0;
}

sub init_win {
  my $win = Gtk2::Window->new('toplevel');
  $win->signal_connect('delete-event' => sub {Gtk2->main_quit()});
  $win->set_title('PocketCalc Unfinished');
  $win->set_border_width(5);
  $win->set_position('center-always');
  my $table = fill_table();
  $win->add($table);
  $win->show_all();
  Gtk2->main();
}

sub fill_table {
  my $tbl = Gtk2::Table->new(7, 5, FALSE);
  
  my $btn_x = Gtk2::Button->new('X');
  $btn_x->signal_connect('button-release-event' => \&rec_x);
  $tbl->attach_defaults ($btn_x, 0, 1, 0, 1);

  $Display = Gtk2::Entry->new();
  $Display->set_text('0');
  #$Display->signal_connect(changed => sub {
  #  my $text = $Display->get_text;
  #});
  $tbl->attach_defaults($Display, 1, 6, 0, 1);

  my $btn_ms = Gtk2::Button->new('MS');
  $btn_ms->signal_connect('button-release-event' => \&rec_ms);
  $tbl->attach_defaults ($btn_ms, 6, 7, 0, 1);

  my $btn_neg = Gtk2::Button->new('±');
  $btn_neg->signal_connect('button-release-event' => \&rec_neg);
  $tbl->attach_defaults ($btn_neg, 0, 1, 1, 2);

  my $btn_7 = Gtk2::Button->new('7');
  $btn_7->signal_connect('button-release-event' => \&rec_7);
  $tbl->attach_defaults ($btn_7, 1, 2, 1, 2);

  my $btn_8 = Gtk2::Button->new('8');
  $btn_8->signal_connect('button-release-event' => \&rec_8);
  $tbl->attach_defaults ($btn_8, 2, 3, 1, 2);

  my $btn_9 = Gtk2::Button->new('9');
  $btn_9->signal_connect('button-release-event' => \&rec_9);
  $tbl->attach_defaults ($btn_9, 3, 4, 1, 2);

  my $btn_pct = Gtk2::Button->new('%');
  $btn_pct->signal_connect('button-release-event' => \&rec_pct);
  $tbl->attach_defaults ($btn_pct, 4, 5, 1, 2);

  my $btn_q = Gtk2::Button->new('?');
  $btn_q->signal_connect('button-release-event' => \&rec_q);
  $tbl->attach_defaults ($btn_q, 5, 6, 1, 2);

  my $btn_mc = Gtk2::Button->new('MC');
  $btn_mc->signal_connect('button-release-event' => \&rec_mc);
  $tbl->attach_defaults ($btn_mc, 6, 7, 1, 2);

  my $btn_sqrt = Gtk2::Button->new('√');
  $btn_sqrt->signal_connect('button-release-event' => \&rec_sqrt);
  $tbl->attach_defaults ($btn_sqrt, 0, 1, 2, 3);

  my $btn_4 = Gtk2::Button->new('4');
  $btn_4->signal_connect('button-release-event' => \&rec_4);
  $tbl->attach_defaults ($btn_4, 1, 2, 2, 3);

  my $btn_5 = Gtk2::Button->new('5');
  $btn_5->signal_connect('button-release-event' => \&rec_5);
  $tbl->attach_defaults ($btn_5, 2, 3, 2, 3);

  my $btn_6 = Gtk2::Button->new('6');
  $btn_6->signal_connect('button-release-event' => \&rec_6);
  $tbl->attach_defaults ($btn_6, 3, 4, 2, 3);

  my $btn_mul = Gtk2::Button->new('×');
  $btn_mul->signal_connect('button-release-event' => \&rec_mul);
  $tbl->attach_defaults ($btn_mul, 4, 5, 2, 3);

  my $btn_div = Gtk2::Button->new('÷');
  $btn_div->signal_connect('button-release-event' => \&rec_div);
  $tbl->attach_defaults ($btn_div, 5, 6, 2, 3);

  my $btn_mr = Gtk2::Button->new('MR');
  $btn_mr->signal_connect('button-release-event' => \&rec_mr);
  $tbl->attach_defaults ($btn_mr, 6, 7, 2, 3);

  my $btn_c = Gtk2::Button->new('C');
  $btn_c->signal_connect('button-release-event' => \&rec_c);
  $tbl->attach_defaults ($btn_c, 0, 1, 3, 4);

  my $btn_1 = Gtk2::Button->new('1');
  $btn_1->signal_connect('button-release-event' => \&rec_1);
  $tbl->attach_defaults ($btn_1, 1, 2, 3, 4);

  my $btn_2 = Gtk2::Button->new('2');
  $btn_2->signal_connect('button-release-event' => \&rec_2);
  $tbl->attach_defaults ($btn_2, 2, 3, 3, 4);

  my $btn_3 = Gtk2::Button->new('3');
  $btn_3->signal_connect('button-release-event' => \&rec_3);
  $tbl->attach_defaults ($btn_3, 3, 4, 3, 4);

  my $btn_add = Gtk2::Button->new('+');
  $btn_add->signal_connect('button-release-event' => \&rec_add);
  $tbl->attach_defaults ($btn_add, 4, 5, 3, 5);

  my $btn_sub = Gtk2::Button->new('-');
  $btn_sub->signal_connect('button-release-event' => \&rec_sub);
  $tbl->attach_defaults ($btn_sub, 5, 6, 3, 4);

  my $btn_m_sub = Gtk2::Button->new('M-');
  $btn_m_sub->signal_connect('button-release-event' => \&rec_m_sub);
  $tbl->attach_defaults ($btn_m_sub, 6, 7, 3, 4);

  my $btn_ac = Gtk2::Button->new('AC');
  $btn_ac->signal_connect('button-release-event' => \&rec_ac);
  $tbl->attach_defaults ($btn_ac, 0, 1, 4, 5);

  my $btn_0 = Gtk2::Button->new('0');
  $btn_0->signal_connect('button-release-event' => \&rec_0);
  $tbl->attach_defaults ($btn_0, 1, 3, 4, 5);

  my $btn_pt = Gtk2::Button->new('.');
  $btn_pt->signal_connect('button-release-event' => \&rec_pt);
  $tbl->attach_defaults ($btn_pt, 3, 4, 4, 5);

  my $btn_eq = Gtk2::Button->new('=');
  $btn_eq->signal_connect('button-release-event' => \&rec_eq);
  $tbl->attach_defaults ($btn_eq, 5, 6, 4, 5);

  my $btn_m_add = Gtk2::Button->new('M+');
  $btn_m_add->signal_connect('button-release-event' => \&rec_m_add);
  $tbl->attach_defaults ($btn_m_add, 6, 7, 4, 5);

  return $tbl;
}

sub rec_x {
  $_op_new = 'X';
  doOp();
}

sub rec_ms {
  $_op_new = 'MS';
  doOp();
}

sub rec_neg {
  $_op_new = '±';
  doOp();
}

sub rec_7 {
  $_value = '7';
  append();
}

sub rec_8 {
#  my ($widget,$event) = @_;
  $_value = '8';
  append();
}

sub rec_9 {
  $_value = '9';
  append();
}

sub rec_pct {
  $_op_new = '%';
  doOp();
}

sub rec_q {
  #TODO
  print("?\n");
}

sub rec_mc {
  $_op_new = 'MC';
  doOp();
}

sub rec_sqrt {
  $_op_new = '√';
  doOp();
}

sub rec_4 {
  $_value = '4';
  append();
}

sub rec_5 {
  $_value = '5';
  append();
}

sub rec_6 {
  $_value = '6';
  append();
}

sub rec_mul {
  $_op_new = '*';
  doOp();
}

sub rec_div {
  $_op_new = '/';
  doOp();
}

sub rec_mr {
  $_op_new = 'MR';
  doOp();
}

sub rec_c {
  $_op_new = 'C';
  doOp();
}

sub rec_1 {
  $_value = '1';
  append();
}

sub rec_2 {
  $_value = '2';
  append();
}

sub rec_3 {
  $_value = '3';
  append();
}

sub rec_add {
  $_op_new = '+';
  doOp();
}

sub rec_sub {
  $_op_new = '-';
  doOp();
}

sub rec_m_sub {
  $_op_new = 'M-';
  doOp();
}

sub rec_ac {
  $_op_new = 'AC';
  doOp();
}

sub rec_0 {
  $_value = '0';
  append();
}

sub rec_pt {
  $_value = '.';
  append();
}

sub rec_eq {
  $_op_new = '=';
  doOp();
}

sub rec_m_add {
  $_op_new = 'M+';
  doOp();
}

sub append {
  $b_Event = 1;
  $_b_decimal_extra = 0;
  if ($_value eq '.') {
    if (!$_b_decimal) {
      if ($_b_new_number) {
        $Display->set_text('0');
        $_b_new_number = 0;
      }
      $_b_decimal = 1;
    }
    else {
      $_b_decimal_extra = 1;
    }
  }
  if (!$_b_decimal_extra) {
    if ($_b_new_number) {
      $Display->set_text($_value);
      if ($_value ne '0') {
        $_b_new_number = 0;
      }
    }
    else {
      $Display->set_text($Display->get_text=~tr/,/./r . $_value);
    }
  }
}

sub doOp {
  $b_Event = 1;
  if ($_b_percent) {
    if ($_op_new ne '+' && $_op_new ne '-') {
      $_b_percent = 0;
    }
  }
  if (!$_b_percent) {
    if ($_op_new eq '+' || $_op_new eq '-' || $_op_new eq '*' || $_op_new eq '/') {
      if ($_b_new_number) {
        if ($_op_new eq $_op && !$_b_constant) {
          $_b_constant = 1;
          $_constant = $Display->get_text=~tr/,/./r;
          $_op_constant = $_op_new;
        }
        else {
          $_b_constant = 0;
        }
      }
      else {
        $_b_constant = 0;
      }
      eq_code();
    }
    else {
      $_op_arg = $_op_new;
      b_eq_op();
      if ($_b_eq_op) {
        eq_code();
      }
    }
  }
  if ($_op_new eq '+') {
    if ($_b_percent) {
      $_reg = $_first + $_reg;
      $Display->set_text($_reg);
      $_b_percent = 0;
    } 
  }
  elsif ($_op_new eq '-') {
    if ($_b_percent) {
      $_reg = $_first - $_reg;
      $Display->set_text($_reg);
      $_b_percent = 0;
    }
  }
  elsif ($_op_new eq '±') {
    $Display->set_text(-1*$Display->get_text=~tr/,/./r);
    $_op_arg = $_op;
    b_eq_op();
    if ($_b_eq_op) {
      $_reg = $Display->get_text=~tr/,/./r;
    }
    full();
  }
  elsif ($_op_new eq '√') {
    $Display->set_text(sqrt($Display->get_text=~tr/,/./r));
    fix_function();
  }
  elsif ($_op_new eq 'C') {
    $Display->set_text('0');
    $_op_arg = $_op;
    b_eq_op();
    if ($_b_eq_op) {
      $_reg = $Display->get_text=~tr/,/./r;
    }
    $_b_new_number = 1;
    $_b_decimal = 0;
    $_b_function = 0;
  }
  elsif ($_op_new eq 'AC') {
    $Display->set_text('0');
    $_op = '';
    $_reg = 0;
    $_b_new_number = 1;
    $_b_decimal = 0;
    $_b_constant = 0;
    $_b_function = 0;
  }
  elsif ($_op_new eq 'MC') {
    $_memories[$_memory_idx] = 0;
  }
  elsif ($_op_new eq 'MR') {
    $Display->set_text($_memories[$_memory_idx]);
    fix_function();
  }
  elsif ($_op_new eq 'X') {
    $_temp = $_memory_temp;
    $_memory_temp = $Display->get_text=~tr/,/./r;
    $Display->set_text($_temp);
    fix_function();
  }
  elsif ($_op_new eq 'M-') {
    $_memories[$_memory_idx] -= $_reg;
  }
  elsif ($_op_new eq 'M+') {
    $_memories[$_memory_idx] += $_reg;
  }
  elsif ($_op_new eq 'MS') {
    $_memory_idx = floor(0.5+$Display->get_text=~tr/,/./r)+1;
    if ($_memory_idx >= @_memories) {
      for ($_i = @_memories; $_i <= $_memory_idx; ++$_i) {
        $_memories[$_i] = 0;
      }
    }
  }  
}

sub eq_code {
  $_op_arg = $_op_new;
  b_eq_op();
  if (!$_b_new_number || $_b_function || $_b_eq_op) {
    if ($_b_constant) {
      $_reg = $_constant;
      $_op = $_op_constant;
    }
    $_b_percent = ($_op_new eq '%');
    if ($_b_percent) {
      $_first = $_reg;
    }
    if ($_op eq '+') {
      $_reg += $Display->get_text=~tr/,/./r;
    }
    elsif ($_op eq '-') {
      $_reg -= $Display->get_text=~tr/,/./r;
    }
    elsif ($_op eq '*') {
      $_reg *= $Display->get_text=~tr/,/./r;
    }
    elsif ($_op eq '/') {
      $_reg /= $Display->get_text=~tr/,/./r;
    }
    else {
      $_op_arg = $_op;
      b_eq_op();
      if ($_b_eq_op || $_op eq '') {
        $_reg = $Display->get_text=~tr/,/./r;
      }
    }
    if ($_b_percent) {
      $_reg /= 100;
    }
    $Display->set_text($_reg);
    full();
  }
  $_op = $_op_new;
  $_b_new_number = 1;
  $_b_decimal = 0;
  $_b_function = 0;
}

sub b_eq_op {
  $_b_eq_op = ($_op_arg eq '=' || $_op_arg eq 'M-' || $_op_arg eq 'M-' || $_op_arg eq 'M+' || $_op_arg eq 'MS' || $_op_arg eq '%');
}

sub full {
  $Display->set_text('' . $Display->get_text=~tr/,/./r) # Does nothing useful in Perl.
}

sub fix_function {
  $_op_arg = $_op;
  b_eq_op();
  if ($_b_eq_op) {
    $_reg = $Display->get_text=~tr/,/./r;
  }
  $_b_new_number = 1;
  $_b_decimal = 0;
  $_b_function = 1;
  full();
}
