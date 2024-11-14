#!/usr/bin/env perl

use Mojolicious::Lite -signatures;

our %ENV;
use lib ($ENV{LOGPARSER_HOME}.'/lib');

use Gazprom::Config;
use Gazprom::DB;

use constant RESULT_ROWS_MAX => 100;

my $script_home_dir = $ENV{LOGPARSER_HOME} or
	die("LOGPARSER_HOME env variable is not set");
my $config_file = "$script_home_dir/etc/logparser.conf";

my $config = Gazprom::Config->get_config($config_file);
Gazprom::DB->init(config => $config);
my $dbh = Gazprom::DB->get_connection();

get '/search' => sub ($c) {
  $c->render(template => 'search_form', result => []);
};

post '/search' => sub ($c) {
    my $address = $c->param('address');

    my $search_sql = "
        SELECT int_id, created, str FROM message WHERE str ILIKE ?
        UNION
        SELECT int_id, created, str FROM log WHERE address = ?
        ORDER BY int_id ASC, created ASC
    ";

    my $count_sql = "SELECT COUNT(*) FROM ($search_sql) AS search";

    # Let's count the result set
    my $query = $count_sql; 
    my $sth = $dbh->prepare($query) or
        die "Cannot prepare $query !!! Resason: ".$dbh->errstr();
    $sth->execute('%'.$address.'%', $address) or
        die "Error executing $query !!! Reason: ". $dbh->errstr();
    my $result = $sth->fetchrow_arrayref();
    my $rows_num = $result->[0];

    if ($rows_num > RESULT_ROWS_MAX) {
        $c->stash(msg => 'More than '.RESULT_ROWS_MAX.
            ' rows returned! Limiting to '.RESULT_ROWS_MAX);
        $search_sql .= ' LIMIT '.RESULT_ROWS_MAX;
    }

    # Run the actual search query
    $query = $search_sql;
    $sth = $dbh->prepare($query) or
        die "Cannot prepare $query !!! Resason: ".$dbh->errstr();
    $sth->execute('%'.$address.'%', $address) or
        die "Error executing $query !!! Reason: ". $dbh->errstr();
    $result = $sth->fetchall_arrayref({});
    $c->render(template => 'search_form', result => $result);
};
 
app->start;

__DATA__

@@ search_form.html.ep
<form method="POST">
<label for="address">Address:</label>
<input type="text" id="address" name="address" required size="10" />
<input type="submit" value="Search" />
</form>
<% if (scalar(@$result)) { %>
<table>
<tr>
    <th>Created</th>
    <th>Log</th>
</tr>
<% for my $row (@$result) { %>
<tr>
    <td><%= $row->{created} %></td>
    <td><%= $row->{str} %></td>
</tr>
<% } %>
</table>
<% } %>
