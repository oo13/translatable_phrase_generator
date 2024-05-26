--[[
   Test Functions

   Tested only in the 8 bit encoding.
--]]
local ut = require("ut")

package.path = "./?.lua;../scripts/?.lua" -- must fail to require("lua-utf8")
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

-- Clear the error messages and the random sequence.
ut.set_enter(function ()
   phrase.require_utf8(false)
   ut.set_random_sequence({})
   error_messages = ""
   error_is_expected = false
end)
-- Check if some errors are detected.
ut.set_leave(function ()
   return error_is_expected ~= (error_messages == "")
end)


local tests = {}

function tests.new_no_parameters()
   local ph = phrase.new()
   return
      ph.type_phrase and
      ph:get_number_of_syntax() == 0 and
      ph:get_combination_number() == 0 and
      ph:get_weight() == 0 and
      ph:generate() == "nil"
end

function tests.new_no_main()
   error_is_expected = true
   local ph = phrase.new([[A = A]])
   return
      ph.type_phrase and
      ph:get_number_of_syntax() == 0 and
      ph:get_combination_number() == 0 and
      ph:get_weight() == 0 and
      ph:generate() == "nil"
end

function tests.new_syntax_error()
   error_is_expected = true
   local ph = phrase.new([[main = }A]])
   return
      ph.type_phrase and
      ph:get_number_of_syntax() == 0 and
      ph:get_combination_number() == 0 and
      ph:get_weight() == 0 and
      ph:generate() == "nil"
end

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

function tests.new_with_a_valid_parameter()
   local ph = phrase.new([[main = A]])
   return
      ph.type_phrase and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "A"
end

function tests.new_with_a_compiled_data()
   local compiled = phrase.compile([[main = A]])
   local ph = phrase.new(compiled)
   return
      ph.type_phrase and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "A"
end

function tests.compile_no_parameters()
   local compiled = phrase.compile()
   return
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data:get_combination_number() == 0 and
      compiled.data:get_weight() == 0
end

function tests.compile_empty_string()
   local compiled = phrase.compile("")
   return
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data:get_combination_number() == 0 and
      compiled.data:get_weight() == 0
end

function tests.compile_no_assignment()
   local compiled = phrase.compile("   \n \n \t")
   return
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data:get_combination_number() == 0 and
      compiled.data:get_weight() == 0
end

function tests.compile_syntax_error()
   error_is_expected = true
   local compiled = phrase.compile([[main = }A]])
   return compiled == nil
end

function tests.compile_fatal_error_without_parameter()
   phrase.require_utf8(true)
   error_is_expected = true
   local compiled = phrase.compile()
   return compiled == nil
end

function tests.new_fatal_error_with_a_parameter()
   phrase.require_utf8(true)
   error_is_expected = true
   local compiled = phrase.compile([[main = A]])
   return compiled == nil
end

function tests.compile_with_a_valid_parameter()
   local compiled = phrase.compile([[A = B]])
   local result = compiled.type_compiled_syntax and compiled.data.type_syntax
   compiled:add([[main = {A}]])
   local ph = phrase.new(compiled)
   return result and ph:generate() == "B"
end

function tests.phrase_add_1()
   local ph = phrase.new()
   local result = ph:add([[main = 2]])
   return
      result and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "2"
end

function tests.phrase_add_2()
   ut.set_random_sequence({ 0.9 })
   local ph = phrase.new([[main = 1]])
   local result = ph:add([[main = 2]])
   return
      result and
      ph:get_number_of_syntax() == 2 and
      ph:get_combination_number() == 2 and
      ph:get_weight() == 2 and
      ph:generate() == "2"
end

function tests.phrase_add_compiled_1()
   local ph = phrase.new()
   local compiled = phrase.compile([[main = 2]])
   local result = ph:add(compiled)
   return
      result and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "2"
end

function tests.phrase_add_compiled_2()
   ut.set_random_sequence({ 0.9 })
   local ph = phrase.new([[main = 1]])
   local compiled = phrase.compile([[main = 2]])
   local result = ph:add(compiled)
   return
      result and
      ph:get_number_of_syntax() == 2 and
      ph:get_combination_number() == 2 and
      ph:get_weight() == 2 and
      ph:generate() == "2"
end

function tests.phrase_add_parameter_type_error()
   ut.set_random_sequence({ 0.9 })
   local ph = phrase.new([[main = 1]])
   error_is_expected = true
   local result = ph:add(1)
   return
      not result and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "1"
end

function tests.phrase_add_syntax_error()
   ut.set_random_sequence({ 0.9 })
   local ph = phrase.new([[main = 1]])
   error_is_expected = true
   local result = ph:add([[main = }2]])
   return
      not result and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "1"
end

function tests.phrase_add_without_main()
   ut.set_random_sequence({ 0.9 })
   local ph = phrase.new([[main = 1]])
   error_is_expected = true
   local result = ph:add([[sub = 2]])
   return
      not result and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "1"
end

function tests.compile_add_1()
   local compiled = phrase.compile()
   local result = compiled:add([[B = 2]])
   return
      result and
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data.assignments["B"]
end

function tests.compile_add_2()
   local compiled = phrase.compile([[A = 1]])
   local result = compiled:add([[B = 2]])
   return
      result and
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data.assignments["A"] and
      compiled.data.assignments["B"]
end

function tests.compile_add_compiled_1()
   local compiled = phrase.compile()
   local result = compiled:add(phrase.compile([[B = 2]]))
   return
      result and
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data.assignments["B"]
end

function tests.compile_add_compiled_2()
   local compiled = phrase.compile([[A = 1]])
   local result = compiled:add(phrase.compile([[B = 2]]))
   return
      result and
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data.assignments["A"] and
      compiled.data.assignments["B"]
end

function tests.compile_add_parameter_type_error()
   local compiled = phrase.compile([[A = 1]])
   error_is_expected = true
   local result = compiled:add(1)
   return
      not result and
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data.assignments["A"]
end

function tests.compile_add_syntax_error()
   local compiled = phrase.compile([[A = 1]])
   error_is_expected = true
   local result = compiled:add([[B = }2]])
   return
      not result and
      compiled.type_compiled_syntax and
      compiled.data.type_syntax and
      compiled.data.assignments["A"] and
      not compiled.data.assignments["B"]
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

function tests.compile_add_overwrite_nonterminal()
   local compiled = phrase.compile([[A = 1]])
   local result = compiled:add([[A = 2]])
   compiled:add([[main = {A}]])
   local ph = phrase.new(compiled)
   return
      result and
      ph:get_number_of_syntax() == 1 and
      ph:get_combination_number() == 1 and
      ph:get_weight() == 1 and
      ph:generate() == "2"
end

return ut.runner("Function Test", tests, { verbose = false })
