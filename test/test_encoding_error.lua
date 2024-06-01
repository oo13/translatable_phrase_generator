--[[
   Test to raise the encoding error

   The test under the condition that fails to require("lua-utf8").
--]]
local unit_test = require("unit_test")

-- must fail to require("lua-utf8")
package.path = "./?.lua;../scripts/?.lua"
package.cpath = ""
local phrase = require("phrase")


local test_encoding_error = {}

function test_encoding_error.run_test()
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

   -- Clear the error messages and the random sequence.
   ut:set_enter(function ()
      phrase.require_utf8(false)
      ut:set_random_sequence({})
      error_messages = ""
      error_is_expected = false
   end)
   -- Check if some errors are detected.
   ut:set_leave(function ()
      return error_is_expected ~= (error_messages == "")
   end)


   local tests = {}

   function tests.new_fatal_error_without_parameter()
      phrase.require_utf8(true)
      error_is_expected = true
      local ph = phrase.new()
      return ph == nil
   end

   function tests.new_fatal_error_with_a_parameter()
      phrase.require_utf8(true)
      error_is_expected = true
      local ph = phrase.new([[main = A]])
      return ph == nil
   end

   function tests.compile_fatal_error_without_parameter()
      phrase.require_utf8(true)
      error_is_expected = true
      local compiled = phrase.compile()
      return compiled == nil
   end

   function tests.compile_fatal_error_with_a_parameter()
      phrase.require_utf8(true)
      error_is_expected = true
      local compiled = phrase.compile([[main = A]])
      return compiled == nil
   end

   function tests.compile_add_fatal_error()
      local compiled = phrase.compile([[A = 1]])
      phrase.require_utf8(true)
      error_is_expected = true
      local result = compiled:add([[B = 2]])
      return
         not result and
         compiled.type_compiled_syntax and
         compiled.data.type_syntax and
         compiled.data.assignments["A"] and
         not compiled.data.assignments["B"]
   end

   return ut:runner("Character Encoding Error Test", tests, { verbose = false })
end

if test_encoding_error.run_test() > 0 then
   os.exit(1)
else
   os.exit(0)
end
