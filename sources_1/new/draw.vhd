----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.08.2024 17:52:27
-- Design Name: 
-- Module Name: draw - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity draw is
  Port ( 
  vidon:in std_logic;
  is_body: in std_logic;
  is_food: in std_logic;
  is_head: in std_logic;
  vgaRed: out std_logic_vector( 3 downto 0);
  vgaGreen: out std_logic_vector( 3 downto 0);
  vgaBlue: out std_logic_vector( 3 downto 0)
  );
end draw;

architecture Behavioral of draw is

begin

process(is_body, is_food, is_head, vidon)
begin
vgaRed <= "0000";
vgaGreen <= "0000";
vgaBlue <= "0000";

if (vidon = '1') then
    if (is_head = '1' or is_body = '1') then
        vgaRed <= "1111";
        vgaGreen <= "1111";
        vgaBlue <= "1111";
    
    elsif (is_food  = '1') then
        vgaRed <= "1111";
        vgaGreen <= "0000";
        vgaBlue <= "0000";
    
    else
        vgaRed <= "0000";
        vgaGreen <= "0011";
        vgaBlue <= "0010";
    end if;
end if;
end process;


end Behavioral;
