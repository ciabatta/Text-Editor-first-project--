#!usr/bin/perl
#use strict;
use lib "C:/camelbox/site/lib";
use lib "C:/camelbox/lib";
use warnings;
use Path::Class;
#use autodie;
use Data::Dumper;
{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}
use Gtk2 '-init';
use constant TRUE =>1;
use constant FALSE =>0;



my $openfiletitle = "Open File";
my $savefiletitle = "Save";
our $savebutton2title = "Save";
our $openbutton2title = "Open File";
my $window1 = Gtk2::Window->new;
	$window1->set_title('Text  Editor');
	$window1->signal_connect(destroy=> sub{Gtk2_Main_Quit});
	$window1->set_border_width(4);
	$window1->set_default_size(400, 200);
our $Entry1buffer=Gtk2::TextBuffer->new;
our $Entry1 = Gtk2::TextView->new_with_buffer($Entry1buffer);
	$Entry1->set_wrap_mode('char');
	$Entry1->set_editable(1);
my $filesavebutton = Gtk2::Button->new_with_label($savefiletitle);
	$filesavebutton->set_size_request(30,80);
	$filesavebutton->signal_connect(clicked=>sub {savefilefunction{
		my $saveframe=Gtk2::Frame->new("Enter the file name");
			$saveframe->set_border_width(4);
		our $fileentryname=Gtk2::Entry->new_with_max_length(50);
		my $savewindow=Gtk2::Window->new;
			$savewindow->signal_connect(destroy=>sub{Gtk2_Main_Quit});
			$savewindow->set_title("Save Window.");
		my $VBox1=Gtk2::VBox->new;
			my $savefilehbox=Gtk2::HBox->new;
			my $savefileframe=Gtk2::Frame->new("Choose file path and save.");
				$savefileframe->set_border_width(4);
			my $savefileframe2=Gtk2::Frame->new("Choose file path and save.");
				$savefileframe2->set_border_width(4);
			our $savepathchooser=Gtk2::FileChooserButton->new('Choose Save Folder', 'select-folder');
			my $savefilebutton2=Gtk2::Button->new_with_label($savebutton2title);
				$savefilebutton2->signal_connect(clicked=>sub {writefilefunction{
					$Entry1->set_buffer($Entry1buffer);
					my $start=$Entry1buffer->get_start_iter;
					my $end=$Entry1buffer->get_end_iter;
					my $dir = dir($savepathchooser->get_filename); 
					our $writefilename= $fileentryname->get_text;
					my $file = $dir->file($writefilename . ".txt");
					my $file_handle = $file->openw();
					my @list = ($Entry1buffer->get_text($start, $end, 1));
					foreach my $line ( @list ) {
						$file_handle->print($line . "\n");
					}
				}});
			$savewindow->add($VBox1);
				$VBox1->add($saveframe);
					$saveframe->add($fileentryname);
				$VBox1->add($savefilehbox);
					$savefilehbox->add($savefileframe);
						$savefileframe->add($savepathchooser);
					$savefilehbox->add($savefileframe2);
						$savefileframe2->add($savefilebutton2);
				
					
			$savewindow->show_all;
			}});

	
my $fileopenbutton = Gtk2::Button->new_with_label($openfiletitle);
	$fileopenbutton->set_size_request(30,80);
	$fileopenbutton->signal_connect(clicked=>sub {openfilefunction{
		my $openwindow=Gtk2::Window->new;
		my $VBox2=Gtk2::VBox->new;
			my $openframe=Gtk2::Frame->new("Enter name of file to open");
				$openframe->set_border_width(4);
		my $openHbox=Gtk2::HBox->new;
		our $openfilename =Gtk2::FileChooserButton->new('Select a File', 'open');
			$openfilename->set_filename('test.txt');
		our $openfilename2=Gtk2::FileChooserButton->new('Select a Folder', 'select-folder');
			my $openfilebutton2=Gtk2::Button->new_with_label($openbutton2title);
				$openfilebutton2->signal_connect(clicked=>sub {readfilefunction{
					my $dir1 = dir($openfilename2->get_filename); 
					#our $filename2 = $openfilename->get_filename;
					$Entry1->set_buffer($Entry1buffer);
					my $start2=$Entry1buffer->get_start_iter;
					my $file2 = $dir1->file($openfilename->get_filename);
					my $content = $file2->slurp();
					my $file_handle2 = $file2->openr();
					while( my $line1 = $file_handle2->getline() ) {
						$Entry1buffer->insert_interactive($start2, $content, 1);
					}	
				}});
			$VBox2->add($openframe);
				$openframe->add($openHbox);
					$openHbox->add($openfilename);
					$openHbox->add($openfilename2);
			$VBox2->add($openfilebutton2);
		$openwindow->add($VBox2);
		$openwindow->show_all;
				
		}});
my $HBox1 = Gtk2::HBox->new;
	my $table1=Gtk2::Table->new(2, 10, 0);
		$table1->set_col_spacings(10);
		$table1->attach_defaults($filesavebutton,0,1,0,1);
		$table1->attach_defaults($fileopenbutton,1,2,0,1);
	$HBox1->add($table1);
my $VBox3 = Gtk2::VBox->new;
	my $frame1=Gtk2::Frame->new("Text Editor");
		$frame1->set_border_width(4);
			my $scrolledwindow=Gtk2::ScrolledWindow->new(undef, undef);
				$scrolledwindow->set_shadow_type('etched-in');
				$scrolledwindow->set_policy('automatic', 'automatic');
				$scrolledwindow->set_size_request(500,600);
				$scrolledwindow->set_border_width(4);
				$scrolledwindow->add($Entry1);
			$frame1->add($scrolledwindow);
	$VBox3->add($frame1);
	$VBox3->add($HBox1);
$window1->add($VBox3);
$window1->show_all;
Gtk2->main;
