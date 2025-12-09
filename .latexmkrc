# Unified latexmk settings so IDE builds match `make`
#
# Works whether latexmk is run from repo root or from ./tex

use Cwd qw(abs_path);
use File::Basename qw(dirname basename);
use File::Spec;

my $root_file = $root_filename;          # latexmk sets this
return 1 unless defined $root_file;

my $root_abs  = abs_path($root_file);
my $proj_dir  = dirname($root_abs);

# If invoked inside tex/, move one level up to repo root
if (basename($proj_dir) eq 'tex') {
  $proj_dir = dirname($proj_dir);
}

my $build_dir = File::Spec->catdir($proj_dir, 'build');
mkdir $build_dir unless -d $build_dir;

$pdf_mode = 1;
$out_dir  = $build_dir;
$aux_dir  = $build_dir;

# Match IDE flags (synctex + file-line-error)
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# After a successful run, copy the final PDF to repo root like `make` does
$post_run = sub {
  my $pdf = File::Spec->catfile($build_dir, 'computer.pdf');
  my $dest = File::Spec->catfile($proj_dir, 'computer.pdf');
  if (-e $pdf) {
    system('cp', $pdf, $dest);
  }
};

1;
