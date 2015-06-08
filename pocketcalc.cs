// pocketcalc.cs - An unfinished pocket calculator for GTK#
// Author: Mikael O. Bonnier <mikael.bonnier@gmail.com>
// License: GPLv3+
// Install on Linux: sudo apt-get install mono-complete gtk-sharp2
// Build: mcs pocketcalc.cs -pkg:gtk-sharp-2.0 -target:winexe
// Run: mono pocketcalc.exe (or ./pocketcalc.exe)
// See: http://www.maketecheasier.com/write-c-sharp-programs-raspberry-pi/
//   http://www.mono-project.com/docs/gui/gtksharp/installer-for-net-framework/
//     Your mileage may vary. Google is your friend. 
//   json-file from https://scratch.mit.edu/projects/13110194/

using Gtk;
using System;

public class PocketCalc  {

  public static Entry display;

  public static int Main (string[] args)
  {
    Application.Init ();
    Window win = new Window ("PocketCalc");
    win.DeleteEvent += new DeleteEventHandler (Window_Delete);
    win.BorderWidth = 5;
    win.SetPosition (WindowPosition.CenterAlways);

    Table table = new Table (7, 5, false);

    Button btn_x = new Button ("X");
    table.Attach(btn_x, 0, 1, 0, 1);

    display = new Entry ("0");
    table.Attach(display, 1, 6, 0, 1);

    Button btn_ms = new Button ("MS");
    table.Attach(btn_ms, 6, 7, 0, 1);

    Button btn_neg = new Button ("±");
    table.Attach(btn_neg, 0, 1, 1, 2);			

    Button btn_7 = new Button ("7");
    btn_7.Clicked += new EventHandler (rec_7);
    table.Attach(btn_7, 1, 2, 1, 2);			

    Button btn_8 = new Button ("8");
    btn_8.Clicked += new EventHandler (rec_8);
    table.Attach(btn_8, 2, 3, 1, 2);			

    Button btn_9 = new Button ("9");
    btn_9.Clicked += new EventHandler (rec_9);
    table.Attach(btn_9, 3, 4, 1, 2);			

    Button btn_pct = new Button ("%");
    table.Attach(btn_pct, 4, 5, 1, 2);			

    Button btn_q = new Button ("?");
    table.Attach(btn_q, 5, 6, 1, 2);			

    Button btn_mc = new Button ("MC");
    table.Attach(btn_mc, 6, 7, 1, 2);			

    Button btn_sqrt = new Button ("√");
    table.Attach(btn_sqrt, 0, 1, 2, 3);			

    Button btn_4 = new Button ("4");
    btn_4.Clicked += new EventHandler (rec_4);
    table.Attach(btn_4, 1, 2, 2, 3);			

    Button btn_5 = new Button ("5");
    btn_5.Clicked += new EventHandler (rec_5);
    table.Attach(btn_5, 2, 3, 2, 3);			

    Button btn_6 = new Button ("6");
    btn_6.Clicked += new EventHandler (rec_6);
    table.Attach(btn_6, 3, 4, 2, 3);			

    Button btn_mul = new Button ("×");
    table.Attach(btn_mul, 4, 5, 2, 3);			

    Button btn_div = new Button ("÷");
    table.Attach(btn_div, 5, 6, 2, 3);

    Button btn_mr = new Button ("MR");
    table.Attach(btn_mr, 6, 7, 2, 3);			

    Button btn_c = new Button ("C");
    btn_c.Clicked += new EventHandler (rec_c);
    table.Attach(btn_c, 0, 1, 3, 4);			

    Button btn_1 = new Button ("1");
    btn_1.Clicked += new EventHandler (rec_1);
    table.Attach(btn_1, 1, 2, 3, 4);			

    Button btn_2 = new Button ("2");
    btn_2.Clicked += new EventHandler (rec_2);
    table.Attach(btn_2, 2, 3, 3, 4);			

    Button btn_3 = new Button ("3");
    btn_3.Clicked += new EventHandler (rec_3);
    table.Attach(btn_3, 3, 4, 3, 4);			

    Button btn_add = new Button ("+");
    table.Attach(btn_add, 4, 5, 3, 5);

    Button btn_sub = new Button ("-");
    table.Attach(btn_sub, 5, 6, 3, 4);

    Button btn_m_sub = new Button ("M-");
    table.Attach(btn_m_sub, 6, 7, 3, 4);

    Button btn_ac = new Button ("AC");
    btn_ac.Clicked += new EventHandler (rec_ac);
    table.Attach(btn_ac, 0, 1, 4, 5);

    Button btn_0 = new Button ("0");
    btn_0.Clicked += new EventHandler (rec_0);
    table.Attach(btn_0, 1, 3, 4, 5);

    Button btn_pt = new Button (".");
    table.Attach(btn_pt, 3, 4, 4, 5);

    Button btn_eq = new Button ("=");
    table.Attach(btn_eq, 5, 6, 4, 5);			

    Button btn_m_add = new Button ("M+");
    table.Attach(btn_m_add, 6, 7, 4, 5);			

    win.Add (table);
    win.ShowAll ();
    Application.Run ();
    return 0;
  }

  static void Window_Delete (object obj, DeleteEventArgs args)
  {
    Application.Quit ();
    args.RetVal = true;
  }

  static void rec_7 (object obj, EventArgs args)
  {
    append("7");
  }

  static void rec_8 (object obj, EventArgs args)
  {
    append("8");
  }

  static void rec_9 (object obj, EventArgs args)
  {
    append("9");
  }

  static void rec_4 (object obj, EventArgs args)
  {
    append("4");
  }

  static void rec_5 (object obj, EventArgs args)
  {
    append("5");
  }

  static void rec_6 (object obj, EventArgs args)
  {
    append("6");
  }

  static void rec_c (object obj, EventArgs args)
  {
    display.Text = "0";
  }

  static void rec_1 (object obj, EventArgs args)
  {
    append("1");
  }

  static void rec_2 (object obj, EventArgs args)
  {
    append("2");
  }

  static void rec_3 (object obj, EventArgs args)
  {
    append("3");
  }

  static void rec_ac (object obj, EventArgs args)
  {
    display.Text = "0";
  }

  static void rec_0 (object obj, EventArgs args)
  {
    append("0");
  }

  static void append (String number)
  {
    display.Text = display.Text + number;
  }
}
