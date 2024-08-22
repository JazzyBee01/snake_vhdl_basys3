----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2024 20:29:04
-- Design Name: 
-- Module Name: TB_score_board - Behavioral
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


entity TB_score_board is
--  Port ( );
end TB_score_board;

architecture Behavioral of TB_score_board is

component score_board is
    Port ( clk_500Hz : in STD_LOGIC;
           score : in unsigned (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal score: unsigned(15 downto 0);
signal clk: std_logic:= '0';
signal seg: std_logic_vector(6 downto 0);
signal an: std_logic_vector(3 downto 0);
constant period: time := 2ns;

begin
    drive_clk: process
    begin
        clk <= not clk;
        wait for period/2;
    end process;

    score_counter: process
    begin
        if score < 9999 then
            score <= score + 1;
        else
            score <= (others => '0');
        end if;
        wait for 10ns;
    end process;
 
    DUT: score_board
    port map( clk, score, seg, an);

end Behavioral;
