$latex = 'platex %O -synctex=1 %S';
$bibtex = 'pbibtex %O %B';
$makeindex = 'mendex %O -o %D %S';
$dvipdf = 'dvipdfmx %O -o %D %S';
$dvips = 'dvips %O -z -f %S | convbkmk -g > %D';
$ps2pdf = 'ps2pdf %O %S %D';
$pdf_mode = 3;
$pdf_previewer = "open -a preview.app";
