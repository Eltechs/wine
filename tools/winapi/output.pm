package output;

use strict;

my $_output;

sub new {
    my $self = shift;
    $_output = _output->new(@_);
    return $_output;
}

sub AUTOLOAD {
    my $self = shift;

    my $name = $output::AUTOLOAD;
    $name =~ s/^.*::(.[^:]*)$/$1/;

    return $_output->$name(@_);
}

package _output;

use strict;

my $stdout_isatty = -t STDOUT;
my $stderr_isatty = -t STDERR;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};
    bless ($self, $class);

    my $progress = \${$self->{PROGRESS}};
    my $last_progress = \${$self->{LAST_PROGRESS}};
    my $last_time = \${$self->{LAST_TIME}};
    my $progress_count = \${$self->{PROGRESS_COUNT}};
    my $prefix = \${$self->{PREFIX}};

    $$progress = "";
    $$last_progress = "";
    $$last_time = 0;
    $$progress_count = 0;
    $$prefix = "";

    return $self;
}


sub show_progress {
    my $self = shift;
    my $progress = \${$self->{PROGRESS}};
    my $last_progress = \${$self->{LAST_PROGRESS}};
    my $progress_count = \${$self->{PROGRESS_COUNT}};

    $$progress_count++;

    if($$progress_count > 0 && $$progress && $stderr_isatty) {
	print STDERR $$progress;
	$$last_progress = $$progress;
    }
}

sub hide_progress  {
    my $self = shift;
    my $progress = \${$self->{PROGRESS}};
    my $last_progress = \${$self->{LAST_PROGRESS}};
    my $progress_count = \${$self->{PROGRESS_COUNT}};

    $$progress_count--;

    if($$last_progress && $stderr_isatty) {
	my $message;
	for (1..length($$last_progress)) {
	    $message .= " ";
	}
	print STDERR $message;
	undef $$last_progress;
    }
}

sub update_progress {
    my $self = shift;
    my $progress = \${$self->{PROGRESS}};
    my $last_progress = \${$self->{LAST_PROGRESS}};
    
    my $prefix = "";
    my $suffix = "";
    if($$last_progress) {
	for (1..length($$last_progress)) {
	    $prefix .= "";
	}
	
	my $diff = length($$last_progress)-length($$progress);
	if($diff > 0) {
	    for (1..$diff) {
		$suffix .= " ";
	    }
	    for (1..$diff) {
		$suffix .= "";
	    }
	}
    }
    print STDERR $prefix . $$progress . $suffix;
    $$last_progress = $$progress;
}

sub progress {
    my $self = shift;
    my $progress = \${$self->{PROGRESS}};
    my $last_time = \${$self->{LAST_TIME}};

    $$progress = shift;

    $self->update_progress;
    $$last_time = 0;
}

sub lazy_progress {
    my $self = shift;
    my $progress = \${$self->{PROGRESS}};
    my $last_time = \${$self->{LAST_TIME}};

    $$progress = shift;

    my $time = time();
    if($time - $$last_time > 0) {
	$self->update_progress;
    	$$last_time = $time;
    }
}

sub prefix {
    my $self = shift;
    my $prefix = \${$self->{PREFIX}};

    $$prefix = shift;
}

sub write {
    my $self = shift;

    my $message = shift;

    my $prefix = \${$self->{PREFIX}};

    $self->hide_progress if $stdout_isatty;
    print $$prefix . $message;
    $self->show_progress if $stdout_isatty;
}

1;
