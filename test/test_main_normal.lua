--[[
   Normal test main
--]]
package.path = package.path .. ";../scripts/?.lua"
local phrase = require("phrase")

local test_8bit_encoding = require("test_8bit_encoding")
local test_functions = require("test_functions")
local test_generator = require("test_generator")
local test_parser = require("test_parser")
local test_utf8 = require("test_utf8")

local num_err = 0

-- 8 bit encoding
phrase.require_utf8(false)
print("The test for 8 bit encoding.")
num_err = num_err + test_8bit_encoding.run_test()
num_err = num_err + test_functions.run_test()
num_err = num_err + test_generator.run_test()
num_err = num_err + test_parser.run_test()

-- UTF-8 encoding
if not phrase.require_utf8(true) then
   print("The test requires UTF-8 support.")
   num_err = num_err + 1
else
   print("The test for UTF-8 encoding.")
   num_err = num_err + test_functions.run_test()
   num_err = num_err + test_generator.run_test()
   num_err = num_err + test_parser.run_test()
   num_err = num_err + test_utf8.run_test()
end

if num_err > 0 then
   os.exit(1)
else
   os.exit(0)
end
