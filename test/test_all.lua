--[[
   Test main
--]]

local test_functions_result = require("test_functions")
local test_generator_result = require("test_generator")
local test_parser_result = require("test_parser")

if test_functions_result + test_generator_result + test_parser_result > 0 then
   os.exit(1)
else
   os.exit(0)
end
