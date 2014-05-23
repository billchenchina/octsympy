%% Copyright (C) 2014 Colin B. Macdonald and others
%%
%% This file is part of OctSymPy.
%%
%% OctSymPy is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published
%% by the Free Software Foundation; either version 3 of the License,
%% or (at your option) any later version.
%%
%% This software is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty
%% of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
%% the GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public
%% License along with this software; see the file COPYING.
%% If not, see <http://www.gnu.org/licenses/>.

%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{vars} =} symvar (@var{f})
%% @deftypefnx {Function File} {@var{vars} =} symvar (@var{f}, @var{n})
%% Find symbols in expression and return them as a symbolic vector.
%%
%% The symbols are sorted in alphabetic order with capital letters
%% first.  If @var{n} is specified, the @var{n} symbols closest to
%% @code{x} are returned.
%%
%% Example:
%% @example
%% syms x,y
%% f     = x^2+3*x*y-y^2;
%% vars  = findsym (f);
%% vars2 = findsym (f,1);
%% @end example
%%
%% Compatibility with other implementations: the output should
%% match the order of the equivalent command in the Matlab Symbolic
%% Toolbox version 2014a, as documented here:
%% http://www.mathworks.co.uk/help/symbolic/symvar.html
%%
%% @seealso{findsym, findsymbols}
%% @end deftypefn

%% Author: Colin B. Macdonald, Willem J. Atsma (previous versions)
%% Keywords: symbolic

function vars = symvar(F, Nout)

  symlist = findsymbols (F);
  Nlist = length (symlist);

  if (nargin == 1)
    vars = sym([]);
    for i=1:Nlist
      %vars(i) = symlist{i};
      idx.type = '()'; idx.subs = {i};
      vars = subsasgn(vars, idx, symlist{i});
    end

  else
    if (Nout == 0)
      error('number of requested symbols should be positive')
    end


    if (Nlist < Nout)
      if (Nout == 1)
        warning('Asked for one variable, but none found.');
      else
        warning('Asked for %d variables, but only %d found.',Nout,Nlist);
      end
      Nout = Nlist;
    end

    vars = sym([]);
    if (Nout == 0)
      return
    end

    symstrings = {};
    for i=1:Nlist
      symstrings{i} = strtrim(disp(symlist{i}));
    end

    %% define a map for resorting
    sortorder = 'xywzvutsrqponmlkjihgfedcbaXYWZVUTSRQPONMLKJIHGFEDCBA';
    AZaz      = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    assert(length(AZaz) == length(sortorder))
    for i=1:length(sortorder)
      map.(sortorder(i)) = AZaz(i);
    end

    symstr_forsort = {};
    for i=1:Nlist
      str = symstrings{i};
      first = str(1);
      str(1) = map.(first);
      symstr_forsort{i} = str;
    end
    symstr_forsort;

    [xs,I] = sort(symstr_forsort);

    for i=1:Nout
      %vars(i) = symlist{i};
      idx.type = '()'; idx.subs = {i};
      vars = subsasgn(vars, idx, symlist{I(i)});
    end

  end
end


%! %% some corner cases
%!assert (isempty (symvar (sym(1))));
%!test
%! disp('*** One warning expected')
%! assert (isempty (symvar (sym(1),1)));
%!test
%! % should fail on symbols
%! try
%!   symvar (sym (1), 0);
%!   waserr = false;
%! catch
%!   waserr = true;
%! end
%! assert (waserr)

%!shared x,y,f
%! x=sym('x'); y=sym('y'); f=x^2+3*x*y-y^2;
%!assert (isequal (symvar (f), [x y]));
%!assert (isequal (symvar (f, 1), x));

%!test %% closest to x
%! syms x y a b c alpha xx
%! assert (isequal (symvar (b*xx*exp(alpha) + c*sin(a*y), 2), [xx y]))

%! %% tests to match Matlab R2013b
%!shared x,y,z,a,b,c,X,Y,Z
%! syms x y z a b c X Y Z

%!test
%! %% X,Y,Z first if no 2nd argument
%! s = prod([x y z a b c X Y Z]);
%! assert (isequal( symvar (s), [X Y Z a b c x y z] ))

%!test
%! %% uppercase have *low* priority with argument?
%! s = prod([x y z a b c X Y Z]);
%! assert (isequal (symvar (s,4), [x, y, z, c] ))

%!test
%! %% closest to x
%! s = prod([y z a b c Y Z]);
%! assert (isequal( symvar (s,6), [ y, z, c, b, a, Y] ))
%! s = prod([a b c Y Z]);
%! assert (isequal( symvar (s,4), [ c, b, a, Y] ))

%!test
%! %% upper case letters in correct order
%! s = X*Y*Z;
%! assert (isequal( symvar (s,3), [X Y Z] ))