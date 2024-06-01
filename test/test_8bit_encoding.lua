--[[
   Test 8 bit encoding

   The test succeeds only in 8 bit encoding.
-]]
local unit_test = require("unit_test")
local phrase = require("phrase")

local test_8bit_encoding = {}

function test_8bit_encoding.run_test()
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

   function tests.parse_error_message()
      local ph = phrase.new()
      error_is_expected = true
      ph:add([[
main {* ああ } ＝ text1 | text2 | text3 ~ /pat1/repl1/ ~ /pat2/repl2/g
      ]])
      return error_messages == [[
Error in the phrase "main {* ああ } ＝ text1 | text2 | text3 ...":
Line#1, Column#18: "=" or ":=" is expected.
]]
   end

   function tests.gsub_substitution()
      local ph = phrase.new()
      ph:add([[
         main = あいう ~ /[あ]/か/]])
      local r = ph:generate()
      return r == "か\129\130いう"
   end

   return ut:runner("8 Bit Encoding Test", tests, { verbose = false })
end

return test_8bit_encoding
