function r = test_infnan()
  c = 0;

  % make sure their pickles contain infinity, otherwise just symbols
  oo = sym(inf);
  c=c+1;  r(c) = ~isempty( strfind(oo.pickle, 'Infinity') )
  oo = sym(-inf);
  c=c+1;  r(c) = ~isempty( strfind(oo.pickle, 'Infinity') )
  oo = sym('inf');
  c=c+1;  r(c) = ~isempty( strfind(oo.pickle, 'Infinity') )
  oo = sym('-inf');
  c=c+1;  r(c) = ~isempty( strfind(oo.pickle, 'Infinity') )
  oo = sym('Inf');
  c=c+1;  r(c) = ~isempty( strfind(oo.pickle, 'Infinity') )
  oo = sym('INF');
  c=c+1;  r(c) = ~isempty( strfind(oo.pickle, 'Infinity') )

  oo = sym(nan);
  c=c+1;  r(c) = isempty( strfind(oo.pickle, 'Symbol') )
  oo = sym('nan');
  c=c+1;  r(c) = isempty( strfind(oo.pickle, 'Symbol') )
  oo = sym('NaN');
  c=c+1;  r(c) = isempty( strfind(oo.pickle, 'Symbol') )
  oo = sym('NAN');
  c=c+1;  r(c) = isempty( strfind(oo.pickle, 'Symbol') )


  snan = sym(nan);
  oo = sym(inf);
  zoo = sym('zoo');
  c=c+1;  r(c) = isinf(oo);
  c=c+1;  r(c) = isinf(zoo);
  c=c+1;  r(c) = isnan(0*oo);
  c=c+1;  r(c) = isnan(0*zoo);
  c=c+1;  r(c) = isnan(snan);
  c=c+1;  r(c) = isinf(oo+oo);
  c=c+1;  r(c) = isnan(oo-oo);
  c=c+1;  r(c) = isnan(oo-zoo);
