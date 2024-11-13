use Mojolicious::Lite -signatures;
 
get '/search' => sub ($c) {
  my $address = $c->param('address');
  $c->render(template => 'search_form');
};
 
app->start;

__DATA__

@@ search_form.html.ep
<form method="POST">
<label for="address">Address:</label>
<input type="text" id="address" name="address" required size="10" />
<input type="submit" value="Search" />
</form>
