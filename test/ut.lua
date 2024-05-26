--[[
   Functions for the unit test.
--]]

local ut = {}

function ut._enter()
end

function ut._leave()
   return true
end

function ut.set_enter(f)
   ut._enter = f
end
function ut.set_leave(f)
   ut._leave = f
end

function ut.runner(test_group_name, tests, params)
   if test_group_name and test_group_name ~= "" then
      io.write('Test Group "' .. test_group_name .. '":\n')
   end
   local num_tests = 0
   local num_errors = 0
   local verbose = params and params.verbose
   local keys = {}
   for name, _ in pairs(tests) do
      keys[#keys + 1] = name
   end
   table.sort(keys)
   for _, name in ipairs(keys) do
      num_tests = num_tests + 1
      if verbose then
         io.write('Testing "' .. name .. '"...')
      end
      ut._enter()
      local result_test = tests[name]()
      local result_leave = ut._leave()
      if result_test and result_leave then
         if verbose then
            io.write(" Done.\n")
         end
      else
         num_errors = num_errors + 1
         if not verbose then
            io.write('Testing "' .. name .. '"...')
         end
         io.write(" Error!\n")
      end
   end
   if num_errors == 0 then
      io.write("No errors are detected")
   elseif num_tests == 1 then
      io.write("An error is detected")
   else
      io.write(num_errors .. " errors are detected")
   end
   if num_tests == 1 then
      io.write(" in 1 test.\n")
   else
      io.write(" in " .. num_tests .. " tests.\n")
   end
   return num_errors
end

-- Set the random sequence
ut._random_sequence = {} -- [ 0.0, 1.0 )
ut._random_sequence_index = 1
function ut.set_random_sequence(seq)
   ut._random_sequence = seq
   ut._random_sequence_index = 1
end

-- Stub random
function ut.stub_random(n)
   local i = ut._random_sequence_index
   local r = 0
   if i <= #ut._random_sequence then
      ut._random_sequence_index = i + 1
      r = ut._random_sequence[i]
   else
      -- select the first option.
      r = 0
   end
   if n ~= nil then
      return math.floor(r * n + 1)
   else
      return r
   end
end

return ut
