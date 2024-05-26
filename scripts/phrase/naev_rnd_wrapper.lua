--[[
   Wrapper function for phrase.set_random_function()

   phrase.set_random_function() accepts only the function that is compatible with math.random(). naev_rnd_wrapper.f is a compatible function using rnd.rnd() in Naev.
--]]
--[[
This module is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This module is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this module.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2024 OOTA, Masato
--]]

local naev_rnd_wrapper = {}

function naev_rnd_wrapper.f (n)
   local v
   if n == nil then
      repeat
         v = rnd.rnd()
      until v < 1.0
      return v
   else
      v = rnd.rnd(n - 1)
      return v + 1
   end
end

return naev_rnd_wrapper
