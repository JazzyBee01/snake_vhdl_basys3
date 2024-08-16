----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.08.2024 22:00:49
-- Design Name: 
-- Module Name: collision_xy - Behavioral
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

entity collision_xy is
    Generic(
        block_width: integer:= 20
    );
    Port ( block1_xy : in STD_LOGIC_VECTOR (31 downto 0);
           block2_xy : in STD_LOGIC_VECTOR (31 downto 1);
           colision : out STD_LOGIC);
end collision_xy;

architecture Behavioral of collision_xy is

signal s_block1_x: STD_LOGIC_VECTOR (15 downto 0);
signal s_block1_y: STD_LOGIC_VECTOR (15 downto 0);
signal s_block2_x: STD_LOGIC_VECTOR (15 downto 0);
signal s_block2_y: STD_LOGIC_VECTOR (15 downto 0);


begin


end Behavioral;
