----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.08.2024 13:25:51
-- Design Name: 
-- Module Name: common - 
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Common is
    subtype xy is std_logic_vector(31 downto 0); 
    type xys is array (integer range <>) of xy;
end package Common;

package body Common is
   -- subprogram bodies here
end Common;
