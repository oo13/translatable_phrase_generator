--[[
   Test Generator
--]]
local unit_test = require("unit_test")
local phrase = require("phrase")

local test_generator = {}

function test_generator.run_test()
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
      phrase.set_random_function(ut:get_stub_random())
      ut:set_random_sequence({})
      error_messages = ""
      error_is_expected = false
   end)
   -- Check if some errors are detected.
   ut:set_leave(function ()
      return error_is_expected ~= (error_messages == "")
   end)


   -- generate linear weight
   local function linear_weight(num)
      local w = {}
      for i = 1, num do
         w[i] = (i - 0.5) / num
      end
      return w
   end

   -- check the distribution
   local function check_distribution(ph, gen, num, dist, allowance)
      local count = {}
      for i = 1, num do
         local t = gen(ph)
         if dist[t] then
            if count[t] then
               count[t] = count[t] + 1
            else
               count[t] = 1
            end
         else
            io.stderr:write('"' .. t .. '" is not expected.\n')
            return false
         end
      end
      local match = true
      for t, ep in pairs(dist) do
         local op = 0
         if count[t] then
            op = count[t] / num
         end
         if math.abs(op - ep) > allowance then
            io.stderr:write('"' .. t .. '"\'s probability ' .. op .. ' is not match the expected ' .. ep .. '.\n')
            match = false
         end
      end
      return match
   end


   local tests = {}

   function tests.no_optinos()
      local ph = phrase.new([[
         main = ""
      ]])
      return ph:generate() == ""
   end

   function tests.no_weight_optinos()
      local ph = phrase.new([[
         main = A | B | C
      ]])
      ut:set_random_sequence(linear_weight(3))
      local r1 = ph:generate()
      local r2 = ph:generate()
      local r3 = ph:generate()
      return
         r1 == "A" and
         r2 == "B" and
         r3 == "C"
   end

   function tests.weighted_optinos()
      local ph = phrase.new([[
         main = A | "B" 2 | "C" 3
      ]])
      ut:set_random_sequence(linear_weight(6))
      local r1 = ph:generate()
      local r2 = ph:generate()
      local r3 = ph:generate()
      local r4 = ph:generate()
      local r5 = ph:generate()
      local r6 = ph:generate()
      return
         r1 == "A" and
         r2 == "B" and
         r3 == "B" and
         r4 == "C" and
         r5 == "C" and
         r6 == "C"
   end

   function tests.weighted_and_equalized_optinos()
      local ph = phrase.new([[
         main := A | "B" 2 | "C" 3
      ]])
      ut:set_random_sequence(linear_weight(6))
      local r1 = ph:generate()
      local r2 = ph:generate()
      local r3 = ph:generate()
      local r4 = ph:generate()
      local r5 = ph:generate()
      local r6 = ph:generate()
      return
         r1 == "A" and
         r2 == "A" and
         r3 == "B" and
         r4 == "B" and
         r5 == "C" and
         r6 == "C"
   end

   function tests.optinos_distribution()
      local ph = phrase.new([[
         main = {A1} | {A2}
         A1 = 0 | 1 | 2
         A2 = {A21} | {A22}
         A21 = 3 | 4
         A22 = 5 | 6 | 7 | 8 | 9
      ]])
      phrase.set_random_function(math.random)
      local dist = {
         ["0"] = 0.1,
         ["1"] = 0.1,
         ["2"] = 0.1,
         ["3"] = 0.1,
         ["4"] = 0.1,
         ["5"] = 0.1,
         ["6"] = 0.1,
         ["7"] = 0.1,
         ["8"] = 0.1,
         ["9"] = 0.1,
      }
      return check_distribution(ph, ph.generate, 100000, dist, 0.01)
   end

   function tests.optinos_distribution_equalized()
      local ph = phrase.new([[
         main = {A1} | {A2}
         A1 = 0 | 1 | 2
         A2 := {A21} | {A22}
         A21 = 3 | 4
         A22 = 5 | 6 | 7 | 8 | 9
      ]])
      phrase.set_random_function(math.random)
      local dist = {
         ["0"] = 0.1,
         ["1"] = 0.1,
         ["2"] = 0.1,
         ["3"] = 0.175,
         ["4"] = 0.175,
         ["5"] = 0.07,
         ["6"] = 0.07,
         ["7"] = 0.07,
         ["8"] = 0.07,
         ["9"] = 0.07,
      }
      return check_distribution(ph, ph.generate, 100000, dist, 0.01)
   end

   function tests.optinos_distribution_weighted()
      local ph = phrase.new([[
         main = text1 | {B}
         B = text2 | "{C}" 2
         C = 1 | 2 | 3
      ]])
      phrase.set_random_function(math.random)
      local dist = {
         ["text1"] = 0.25,
         ["text2"] = 0.25,
         ["1"] = 0.1667,
         ["2"] = 0.1667,
         ["3"] = 0.1667,
      }
      return check_distribution(ph, ph.generate, 100000, dist, 0.01)
   end

   function tests.optinos_distribution_binary_search()
      -- The binary search is used if the number of the options is more than 31.
      local ph = phrase.new([[
         main =
           "00" 5 | "01" | "02" | "03" | "04" | "05" | "06" | "07" | "08" | "09" |
           "10" | "11" 3 | "12" | "13" | "14" | "15" | "16" | "17" | "18" | "19" |
           "20" | "21" | "22" 4 | "23" | "24" | "25" | "26" | "27" | "28" | "29" |
           "30" | "31" | "32" | "33" 2 | "34" | "35" | "36" | "37" | "38" | "39"
      ]])
      phrase.set_random_function(math.random)
      local d = 1.0 / 50.0
      local dist = {
         ["00"] = 5*d, ["01"] = d, ["02"] = d, ["03"] = d, ["04"] = d,
         ["05"] = d, ["06"] = d, ["07"] = d, ["08"] = d, ["09"] = d,
         ["10"] = d, ["11"] = 3*d, ["12"] = d, ["13"] = d, ["14"] = d,
         ["15"] = d, ["16"] = d, ["17"] = d, ["18"] = d, ["19"] = d,
         ["20"] = d, ["21"] = d, ["22"] = 4*d, ["23"] = d, ["24"] = d,
         ["25"] = d, ["26"] = d, ["27"] = d, ["28"] = d, ["29"] = d,
         ["30"] = d, ["31"] = d, ["32"] = d, ["33"] = 2*d, ["34"] = d,
         ["35"] = d, ["36"] = d, ["37"] = d, ["38"] = d, ["39"] = d,
      }
      return check_distribution(ph, ph.generate, 100000, dist, 0.01)
   end

   function tests.anonymous_rule()
      local ph = phrase.new([[
         main = 1{= A | B | C }2
      ]])
      ut:set_random_sequence(linear_weight(3))
      local r1 = ph:generate()
      local r2 = ph:generate()
      local r3 = ph:generate()
      return
         r1 == "1A2" and
         r2 == "1B2" and
         r3 == "1C2"
   end

   function tests.anonymous_rule_weighted()
      local ph = phrase.new([[
         main = 1{= A | "B" 2 | "C" 3}2
      ]])
      ut:set_random_sequence(linear_weight(6))
      local r1 = ph:generate()
      local r2 = ph:generate()
      local r3 = ph:generate()
      local r4 = ph:generate()
      local r5 = ph:generate()
      local r6 = ph:generate()
      return
         r1 == "1A2" and
         r2 == "1B2" and
         r3 == "1B2" and
         r4 == "1C2" and
         r5 == "1C2" and
         r6 == "1C2"
   end

   function tests.anonymous_rule_weighted_and_equalized()
      local ph = phrase.new([[
         main = 1{:=A | "B" 2 | "C" 3 }2
      ]])
      ut:set_random_sequence(linear_weight(6))
      local r1 = ph:generate()
      local r2 = ph:generate()
      local r3 = ph:generate()
      local r4 = ph:generate()
      local r5 = ph:generate()
      local r6 = ph:generate()
      return
         r1 == "1A2" and
         r2 == "1A2" and
         r3 == "1B2" and
         r4 == "1B2" and
         r5 == "1C2" and
         r6 == "1C2"
   end

   function tests.special_expansion()
      local ph = phrase.new([[
         main = "A{(}B{"}C{|}D{~}E{)}F{{}G{*comment}H{
}"
      ]])
      return ph:generate() == 'A{B"C|D~E}F{GH\n'
   end

   function tests.generate_with_parameters()
      local ph = phrase.new([[
         main = {A} {B} {C}
         A = head
         C = tail
      ]])
      return ph:generate({ B = "body", C = "foot" }) == "head body tail"
   end

   function tests.gsub()
      local ph = phrase.new([[
         main = "The quick brown fox jumps over the lazy dog." ~ /jumps/jumped/ ~ |dog|dogs|
      ]])
      return ph:generate() == "The quick brown fox jumped over the lazy dogs."
   end

   function tests.gsub_captured()
      local ph = phrase.new([[
         main = "tail head" ~ /(%w+) (%w+)/%2 %1/
      ]])
      return ph:generate() == "head tail"
   end

   function tests.gsub_number()
      local ph = phrase.new([[
         main = "oooooooooooooooooooo
@@@@@@@@@@@@@@@@@@@@ $$$$$$$$$$$$$$$$$$$$" ~ /o/0/11 ~|@|a|g ~'%$'S'
      ]])
      return ph:generate() == "00000000000ooooooooo\naaaaaaaaaaaaaaaaaaaa S$$$$$$$$$$$$$$$$$$$"
   end

   function tests.expansion_parameters_gsub()
      local ph = phrase.new([[
         main = {A} {B} {C} ~ /head/HEAD/ ~ /tail/TAIL/ ~ /body/BODY/
         A = head
         C = tail
      ]])
      return ph:generate({ B = "body" }) == "HEAD BODY TAIL"
   end

   function tests.sharing_syntax()
      local common = phrase.compile([[
         sub = {sub2}
      ]])
      local main1 = phrase.compile([[
         main = {sub}
         sub2 = 1
      ]])
      local main2 = phrase.compile([[
         main = {sub}
         sub2 = 2
      ]])
      main1:add(common)
      main2:add(common)
      local ph1 = phrase.new(main1)
      local ph2 = phrase.new(main2)
      return ph1:generate() == "1" and ph2:generate() == "2"
   end

   function tests.sharing_syntax_dist()
      local common = phrase.compile([[
         sub = {sub2}
      ]])
      local main1 = phrase.compile([[
         main = {sub}
         sub2 = 1 | 2 | 3 | 4
      ]])
      local main2 = phrase.compile([[
         main = {sub}
         sub2 = A | B
      ]])
      main1:add(common)
      main2:add(common)
      local ph1 = phrase.new(main1)
      local ph2 = phrase.new(main2)

      phrase.set_random_function(math.random)

      local dist1 = {
         ["1"] = 0.25,
         ["2"] = 0.25,
         ["3"] = 0.25,
         ["4"] = 0.25,
      }
      local good1 = check_distribution(ph1, ph1.generate, 100000, dist1, 0.01)

      local dist2 = {
         ["A"] = 0.5,
         ["B"] = 0.5,
      }
      local good2 = check_distribution(ph2, ph2.generate, 100000, dist2, 0.01)

      return good1 and good2
   end

   function tests.overwrite_nonterminal()
      local sub = phrase.compile([[
         sub = A
      ]])
      local main = phrase.compile([[
         main = {sub}
         sub = B
      ]])
      main:add(sub)
      local ph = phrase.new(main)
      return ph:generate() == "A"
   end

   function tests.dont_overwrite_local_nonterminal()
      local sub = phrase.compile([[
         _sub = A
      ]])
      local main = phrase.compile([[
         main = {_sub}
         _sub = B
      ]])
      main:add(sub)
      local ph = phrase.new(main)
      return ph:generate() == "B"
   end


   return ut:runner("Generator Test", tests, { verbose = false })
end

return test_generator
