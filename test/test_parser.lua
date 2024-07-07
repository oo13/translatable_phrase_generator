--[[
   Test Parser
-]]
local unit_test = require("unit_test")
local phrase = require("phrase")

local test_parser = {}

function test_parser.run_test()
   local ut = unit_test.new()

   -- select the first option.
   phrase.set_random_function(ut:get_stub_random())

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
   ut:set_enter(function ()
      error_messages = ""
      error_is_expected = false
   end)
   -- Check if some errors are detected.
   ut:set_leave(function ()
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

   function tests.assignments_top_down()
      local ph = phrase.new()
      ph:add([[
         main = {sub}
         sub = A
      ]])
      local r = ph:generate()
      return r == "A"
   end

   function tests.assignments_bottom_up()
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

   function tests.text_quoted_with_real_number_1()
      local ph = phrase.new()
      ph:add([[
         main = text1 | "text2" 2.1
      ]])
      local r = ph:generate()
      return r == "text1" and ph:get_weight() == 3.1
   end

   function tests.text_quoted_with_real_number_2()
      local ph = phrase.new()
      ph:add([[
         main = text1 | "text2" .32
      ]])
      local r = ph:generate()
      return r == "text1" and ph:get_weight() == 1.32
   end

   function tests.text_quoted_with_all_decimals()
      local ph = phrase.new()
      ph:add([[
         main = text1 | "text2" 12345678901.
      ]])
      local r = ph:generate()
      return r == "text1" and ph:get_weight() == 12345678902
   end

   function tests.text_quoted_number_decimal_only()
      error_is_expected = true
      local ph = phrase.new()
      ph:add([[
         main = text1 | "text2" .
      ]])
      local r = ph:generate()
      return r == "nil"
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
         main = 	'' | "" | `` | {} | '' | {*
         comment }"" |
             '{* comment }' |
      ``]])
      local r = ph:generate()
      return r == "" and ph:get_combination_number() == 8
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

   function tests.gsub_with_real_number()
      error_is_expected = true
      local ph = phrase.new()
      ph:add([[
         main = 1 | 2 | 3 ~ ~A~B~1.1]])
      local r = ph:generate()
      return r == "nil"
   end

   function tests.gsub_with_integer_number()
      local ph = phrase.new()
      ph:add([[
         main = 1 | 2 | 3 ~
           /@//0 ~
           /A//1 ~
           /B//2 ~
           /C//3 ~
           /D//4 ~
           /E//5 ~
           /F//6 ~
           /G//7 ~
           /H//8 ~
           /I//9]])
      local r = ph:generate()
      return r == "1"
   end

   function tests.parse_error_last_line()
      error_is_expected = true
      local ph = phrase.new()
      ph:add([[
         main = 1 | 2 | 3 ~ /A//+]])
      local r = ph:generate()
      return r == "nil"
   end

   function tests.recursive_expansion_error()
      error_is_expected = true
      local ph = phrase.new()
      ph:add([[
         main = {A}
         A = {B}
         B = {C}
         C = {B}
      ]])
      local r = ph:generate()
      return r == "nil"
   end

   function tests.no_local_nonterminal_error()
      error_is_expected = true
      local ph = phrase.new()
      ph:add([[
         main = {A}
         A = {_B}
         B = C
      ]])
      local r = ph:generate()
      return r == "nil"
   end

   function tests.nonterminal_with_weight_1()
      local ph = phrase.new()
      ph:add([[
         main 10 = A | B | C
      ]])
      local r = ph:generate()
      return r == "A" and ph:get_weight() == 10
   end

   function tests.nonterminal_with_weight_2()
      local ph = phrase.new()
      ph:add([[
         main 10.5= A | B | C
      ]])
      local r = ph:generate()
      return r == "A" and ph:get_weight() == 10.5
   end

   function tests.nonterminal_characters()
      local ph = phrase.new()
      ph:add([[
         main = {0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.}
         0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_. = 9
      ]])
      local r = ph:generate()
      return r == "9"
   end

   function tests.redefined_nonterminal_error()
      local ph = phrase.new()
      error_is_expected = true
      ph:add([[
         main = {A}
         A = 1 | 2 | 3
         A = 4 | 5 | 6
      ]])
      local r = ph:generate()
      return r == "nil" and
         string.find(error_messages, 'The nonterminal "A" is already defined.', 1, true)
   end

   return ut:runner("Parser Test", tests, { verbose = false })
end

return test_parser
