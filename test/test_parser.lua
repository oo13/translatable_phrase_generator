--[[
   Test Parser

   Tested only in the 8 bit encoding.-
-]]
local ut = require("ut")

package.path = package.path .. ";../scripts/?.lua"
local phrase = require("phrase")
phrase.require_utf8(false)

-- select the first option.
phrase.set_random_function(ut.stub_random)

-- override the function to check if some errors are detected.
local error_messages = ""
local error_is_expected = false -- It can be changed in the test functions.
function phrase.output_error(err_msg)
   error_messages = error_messages .. err_msg
   if not error_is_expected then
      io.stderr:write(err_msg)
   end
end

-- Clear the error messages.
ut.set_enter(function ()
   error_messages = ""
   error_is_expected = false
end)
-- Check if some errors are detected.
ut.set_leave(function ()
   return error_is_expected ~= (error_messages == "")
end)


local tests = {}

function tests.hello_world()
   local ph = phrase.new()
   ph:add([[main=Hello World.]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.spaces_before_equal()
   local ph = phrase.new()
   ph:add([[main =Hello World.]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.spaces_after_equal()
   local ph = phrase.new()
   ph:add([[main= Hello World.]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.newline_after_equal()
   local ph = phrase.new()
   ph:add([[main=
Hello World.]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.assignment_equal_chance()
   local ph = phrase.new()
   ph:add([[main := Hello World.]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.assignment_trailing_spaces()
   local ph = phrase.new()
   ph:add([[main = Hello World.    {* --}
   {* --- }
 ]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.assignment_after_spaces()
   local ph = phrase.new()
   ph:add([[
   {* --- }


   main = Hello World.]])
   local r = ph:generate()
   return r == "Hello World."
end

function tests.assingments_top_down()
   local ph = phrase.new()
   ph:add([[
      main = {sub}
      sub = A
   ]])
   local r = ph:generate()
   return r == "A"
end

function tests.assingments_bottom_up()
   local ph = phrase.new()
   ph:add([[
      sub = A
      main = {sub}
   ]])
   local r = ph:generate()
   return r == "A"
end

function tests.spaces()
   local ph = phrase.new()
   ph:add([[
       	{* comment } main 	{* comment } =  	{* comment }
        	{* comment } text1 	{* comment } | 	{* comment }
        	{* comment } "text2" 	{* comment } ~  	{* comment }
        	{* comment } /A/Z/ 	{* comment }
        	{* comment } 
        	{* comment } sub 	{* comment } :=  	{* comment }
        	{* comment } 'text3' 	{* comment } | 	{* comment }
        	{* comment } `text4` 	{* comment }
   ]])
   local r = ph:generate()
   return r == "text1"
end

function tests.production_rule_simple()
   local ph = phrase.new()
   ph:add([[
      main = text1 | text2 | text3 ~ /pat1/repl1/ ~ /pat2/repl2/g
   ]])
   local r = ph:generate()
   return r == "text1"
end

function tests.text_quoted()
   local ph = phrase.new()
   ph:add([[
      main = text1 | "text2" 2
      sub = 'text1' 2 | `text2`
   ]])
   local r = ph:generate()
   return r == "text1" and ph:get_weight() == 3
end

function tests.text_nonquoted()
   local ph = phrase.new()
   ph:add([[
      main = 	text1 	|  
        te|xt2
   ]])
   local r = ph:generate()
   return r == "text1" and ph:get_combination_number() == 3
end

function tests.text_empty()
   local ph = phrase.new()
   ph:add([[
      main = 	| |||| {*
      comment }
        |
        {* comment } |
   |]])
   local r = ph:generate()
   return r == "" and ph:get_combination_number() == 9
end



function tests.expansion_prior_rule()
   local ph = phrase.new()
   ph:add([[
      main = "  {"
{'`|~ 	}  "
   ]])
   local r = ph:generate()
   return r == "  \"\n{'`|~ \t  "
end

function tests.expansion_nonterminal_1()
   local ph = phrase.new()
   ph:add([[
      main = "-+{AAA}+="
      AAA = ZZZ
   ]])
   local r = ph:generate()
   return r == "-+ZZZ+="
end

function tests.expansion_nonterminal_2()
   local ph = phrase.new()
   ph:add([[
      main = "-+{1}+="
      1 = ZZZ
   ]])
   local r = ph:generate()
   return r == "-+ZZZ+="
end

function tests.expansion_nonterminal_3()
   local ph = phrase.new()
   ph:add([[
      main = "-+{_}+="
      _ = ZZZ
   ]])
   local r = ph:generate()
   return r == "-+ZZZ+="
end

function tests.expansion_braces()
   local ph = phrase.new()
   ph:add([[
      main = "-+{(}+={)}|-"
   ]])
   local r = ph:generate()
   return r == "-+{+=}|-"
end

function tests.expansion_comment()
   local ph = phrase.new()
   ph:add([[
      main = "-+{*comment}+="
      comment = ZZZ
   ]])
   local r = ph:generate()
   return r == "-++="
end

function tests.expansion_anon_rule_1()
   local ph = phrase.new()
   ph:add([[
      main = "-+{= A | B | C }+="
   ]])
   local r = ph:generate()
   return r == "-+A+="
end

function tests.expansion_anon_rule_2()
   local ph = phrase.new()
   ph:add([[
      main = "-+{:=1|2|3~/1/9/~|2|8|}+="
   ]])
   local r = ph:generate()
   return r == "-+9+="
end

function tests.expansion_anon_rule_3()
   local ph = phrase.new()
   ph:add([[
      main = "-+{=
         A | B | C
      }+="
   ]])
   local r = ph:generate()
   return r == "-+A+="
end


function tests.expansion_unsolved()
   local ph = phrase.new()
   ph:add([[
      main = "-+{AAA}+="
   ]])
   local r = ph:generate()
   return r == "-+AAA+="
end

function tests.gsub_simple()
   local ph = phrase.new()
   ph:add([[
      main = 1 | 2 | 3~/A/C/g
   ]])
   local r = ph:generate()
   return r == "1"
end

function tests.gsub_separator()
   local ph = phrase.new()
   ph:add([[
      main = 1 | 2 | 3~|A|C|g~/B/D/11 ~ "C""]])
   local r = ph:generate()
   return r == "1"
end

return ut.runner("Parser Test", tests, { verbose = false })
