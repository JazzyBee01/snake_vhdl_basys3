----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2024 14:07:30
-- Design Name: 
-- Module Name: draw_xys - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common.all;

entity draw_xys is
    Generic (
        component_xys_length: integer := 100
    );
    
    Port ( 
           clk: in std_logic;
           hc : in STD_LOGIC_vector(9 downto 0);
           vc : in STD_LOGIC_vector(9 downto 0);
           component_xys : in xys (0 to component_xys_length -1 );
           is_draw: out std_logic);
end draw_xys;

architecture Behavioral of draw_xys is

signal is_draw_array : std_logic_vector(0 to component_xys_length-1):= (others => '0');
constant empty_array  : std_logic_vector (0 to component_xys_length -1) := (others => '0');

begin

    gen_body_draw_blocks: for i in 0 to component_xys_length - 1 generate
        body_draw_block: entity work.draw_components port map (
            clk => clk,
            hc => hc,
            vc => vc,
            component_xy => component_xys(i),
            is_draw => is_draw_array(i)
        );
    end generate gen_body_draw_blocks;
    
        -- OR all the is_body signals together
    
    is_draw <= '0' when is_draw_array = empty_array else '1';


end Behavioral;
