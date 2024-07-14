--[[
   Test Functions
--]]
local unit_test = require("unit_test")
local phrase = require("phrase")

local test_functions = {}

function test_functions.run_test()
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
      ut:set_random_sequence({})
      error_messages = ""
      error_is_expected = false
   end)
   -- Check if some errors are detected.
   ut:set_leave(function ()
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

   function tests.new_with_a_valid_parameter()
      local ph = phrase.new([[main = A]])
      return
         ph.type_phrase and
         ph:get_number_of_syntax() == 1 and
         ph:get_combination_number() == 1 and
         ph:get_weight() == 1 and
         ph:generate() == "A"
   end

   function tests.new_with_a_start_condition()
      local ph = phrase.new([[start = A]], 'start')
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
      ut:set_random_sequence({ 0.9 })
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
      ut:set_random_sequence({ 0.9 })
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
      ut:set_random_sequence({ 0.9 })
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
      ut:set_random_sequence({ 0.9 })
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
      ut:set_random_sequence({ 0.9 })
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

   function tests.phrase_add_with_start_condition()
      ut:set_random_sequence({ 0.9 })
      local ph = phrase.new([[main = 1]])
      local result = ph:add([[sub = 2]], 'sub')
      return
         result and
         ph:get_number_of_syntax() == 2 and
         ph:get_combination_number() == 2 and
         ph:get_weight() == 2 and
         ph:generate() == "2"
   end

   function tests.phrase_remove_first()
      ut:set_random_sequence({ 0.9, 0.9, 0.9, 0.9, 0.9, 0.9 })
      local ph = phrase.new()
      local id1 = ph:add([[main = "1" 2 | 2 | 3]])
      local id2 = ph:add([[main = A | "B" 3 | C]])
      local id3 = ph:add([[main = あ | い | "う" 4]])
      local r3 = ph:generate()
      local n3 = ph:get_number_of_syntax()
      local c3 = ph:get_combination_number()
      local w3 = ph:get_weight()
      local del3 = ph:remove(id1)
      local r2 = ph:generate()
      local n2 = ph:get_number_of_syntax()
      local c2 = ph:get_combination_number()
      local w2 = ph:get_weight()
      local del2 = ph:remove(id2)
      local r1 = ph:generate()
      local n1 = ph:get_number_of_syntax()
      local c1 = ph:get_combination_number()
      local w1 = ph:get_weight()
      local del1 = ph:remove(id3)
      local r0 = ph:generate()
      local n0 = ph:get_number_of_syntax()
      local c0 = ph:get_combination_number()
      local w0 = ph:get_weight()
      return
         del1 and del2 and del3 and
         id1 and id2 and id3 and
         r3 == "う" and r2 == "う" and r1 == "う" and r0 == "nil" and
         n3 == 3 and n2 == 2 and n1 == 1 and n0 == 0 and
         c3 == 9 and c2 == 6 and c1 == 3 and c0 == 0 and
         w3 == 15 and w2 == 11 and w1 == 6 and w0 == 0
   end

   function tests.phrase_remove_last()
      ut:set_random_sequence({ 0.9, 0.9, 0.9, 0.9, 0.9, 0.9 })
      local ph = phrase.new()
      local id1 = ph:add([[main = "1" 2 | 2 | 3]])
      local id2 = ph:add([[main = A | "B" 3 | C]])
      local id3 = ph:add([[main = あ | い | "う" 4]])
      local r3 = ph:generate()
      local n3 = ph:get_number_of_syntax()
      local c3 = ph:get_combination_number()
      local w3 = ph:get_weight()
      local del3 = ph:remove(id3)
      local r2 = ph:generate()
      local n2 = ph:get_number_of_syntax()
      local c2 = ph:get_combination_number()
      local w2 = ph:get_weight()
      local del2 = ph:remove(id2)
      local r1 = ph:generate()
      local n1 = ph:get_number_of_syntax()
      local c1 = ph:get_combination_number()
      local w1 = ph:get_weight()
      local del1 = ph:remove(id1)
      local r0 = ph:generate()
      local n0 = ph:get_number_of_syntax()
      local c0 = ph:get_combination_number()
      local w0 = ph:get_weight()
      return
         del1 and del2 and del3 and
         id1 and id2 and id3 and
         r3 == "う" and r2 == "C" and r1 == "3" and r0 == "nil" and
         n3 == 3 and n2 == 2 and n1 == 1 and n0 == 0 and
         c3 == 9 and c2 == 6 and c1 == 3 and c0 == 0 and
         w3 == 15 and w2 == 9 and w1 == 4 and w0 == 0
   end

   function tests.phrase_remove_middle()
      ut:set_random_sequence({ 0.9, 0.9, 0.9, 0.9, 0.9, 0.9 })
      local ph = phrase.new()
      local id1 = ph:add([[main = "1" 2 | 2 | 3]])
      local id2 = ph:add([[main = A | "B" 3 | C]])
      local id3 = ph:add([[main = あ | い | "う" 4]])
      local r3 = ph:generate()
      local n3 = ph:get_number_of_syntax()
      local c3 = ph:get_combination_number()
      local w3 = ph:get_weight()
      local del3 = ph:remove(id2)
      local r2 = ph:generate()
      local n2 = ph:get_number_of_syntax()
      local c2 = ph:get_combination_number()
      local w2 = ph:get_weight()
      local del2 = ph:remove(id1)
      local r1 = ph:generate()
      local n1 = ph:get_number_of_syntax()
      local c1 = ph:get_combination_number()
      local w1 = ph:get_weight()
      local del1 = ph:remove(id3)
      local r0 = ph:generate()
      local n0 = ph:get_number_of_syntax()
      local c0 = ph:get_combination_number()
      local w0 = ph:get_weight()
      return
         del1 and del2 and del3 and
         id1 and id2 and id3 and
         r3 == "う" and r2 == "う" and r1 == "う" and r0 == "nil" and
         n3 == 3 and n2 == 2 and n1 == 1 and n0 == 0 and
         c3 == 9 and c2 == 6 and c1 == 3 and c0 == 0 and
         w3 == 15 and w2 == 10 and w1 == 6 and w0 == 0
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

   function tests.compile_add_overwrite_nonterminal()
      error_is_expected = true
      local compiled = phrase.compile([[A = 1]])
      local result = compiled:add([[A = 2]])
      compiled:add([[main = {A}]])
      local ph = phrase.new(compiled)
      return
         result and
         ph:get_number_of_syntax() == 1 and
         ph:get_combination_number() == 1 and
         ph:get_weight() == 1 and
         ph:generate() == "2" and
         error_messages == 'The nonterminal "A" is already defined.\n'
   end

   return ut:runner("Function Test", tests, { verbose = false })
end

return test_functions
