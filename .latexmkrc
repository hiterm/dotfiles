# pythontexが動くように
add_cus_dep('pytxcode', 'tex', 0, 'pythontex');
sub pythontex {
    # This subroutine is a fudge, because it from latexmk's point of
    # view, it makes the main .tex file depend on the .pytxcode file.
    # But it doesn't actually make the .tex file, but is used for its
    # side effects in creating other files.  The dependence is a way
    # of triggering the rule to be run whenever the .pytxcode file
    # changes, and to do this before running latex/pdflatex again.
    return system("pythontex \"$_[0]\"") ;
}

$latex = 'internal mylatex %R %Z uplatex %O -synctex=1 %S';
sub mylatex {
   my $root = shift;
   my $dir_string = shift;
   my $code = "$root.pytxcode";
   my $result = "pythontex-files-$root";
   if ($dir_string) {
      warn "mylatex: Making symlinks to fool cus_dep creation\n";
      unlink $code;
      if (-l $result) {
          unlink $result;
      }
      elsif (-d $result) {
         unlink glob "$result/*";
         rmdir $result;
      }
      symlink $dir_string.$code, $code;
      if ( ! -e $dir_string.$result ) { mkdir $dir_string.$result; }
      symlink $dir_string.$result, $result;
   }
   else {
      foreach ($code, $result) { if (-l) { unlink; } }
   }
   return system @_;
}


$pdflatex = 'lualatex %O -synctex=1 %S';
$bibtex = 'pbibtex %O %B';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars';
$makeindex = 'mendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -g > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 3;
$pdf_previewer = "open -a preview.app";
