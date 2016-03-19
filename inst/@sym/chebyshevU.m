%% Copyright (C) 2016, Abhinav Tripathi
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
%% @documentencoding UTF-8
%% @deftypefn  {Function File} {@var{s} =} chebyshevU (@var{n}, @var{x})
%% Find the nth symbolic Chebyshev polynomial of the second kind.
%%
%% Examples:
%% @example
%% @group
%% syms x
%% chebyshevU(1, x)
%%   @result{} (sym) 2⋅x
%% chebyshevU(2, x)
%%   @result{} (sym)
%%          2
%%       4⋅x  - 1
%% syms n
%% chebyshevU(n, x)
%%   @result{} (sym) chebyshevu(n, x)
%% @end group
%% @end example
%%
%% @seealso{chebyshevT}
%% @end deftypefn

%% Author: Abhinav Tripathi
%% Keywords: symbolic

function y = chebyshevU(n, x)
  cmd = { 'n, x = _ins'
          'return chebyshevu(n, x)' };

  y = python_cmd (cmd, sym(n), sym(x));
end

%!shared x
%! syms x

%!assert(isequal(chebyshevU(0, x), sym(1)))
%!assert(isequal(chebyshevU(1, x), 2*x))
%!assert(isequal(chebyshevU(2, x), 4*x*x - 1))