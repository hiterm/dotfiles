$latex = 'uplatex %O -synctex=1 %S';
$pdflatex = 'luajittex --fmt=luajitlatex %O -synctex=1 %S';
$bibtex = 'upbibtex %O %B';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars';
$makeindex = 'mendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -g > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 3;
if ($^O eq 'derwin') {
    $pdf_previewer = "open -ga /Applications/Skim.app";
} elsif ($^O eq 'linux') {
    $pdf_previewer = "evince";
}
