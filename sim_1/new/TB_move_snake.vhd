library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common.all;

entity TB_move_snake is
--  Port ( );
end TB_move_snake;

architecture Behavioral of TB_move_snake is

component move_snake is
    Generic (   snake_begin_pos_x: integer := 20;
                snake_begin_pos_y: integer := 20;
                head_width: integer := 20;
                screen_width: integer := 640;
                screen_height: integer := 480;
                snake_length_max: integer:= 5
                );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           direction : in STD_LOGIC_VECTOR (1 downto 0);
           head_xy : out std_logic_vector (31 downto 0);
           snake_body_xy: out xys (0 to snake_length_max - 1);
           speed_sel: in std_logic_vector(1 downto 0)
           );
end component;

signal clk: std_logic:= '0';
signal reset: std_logic:= '0';
signal direction: std_logic_vector(1 downto 0):= "00";
signal PERIOD: time:= 10ns;

begin

DUT: move_snake
port map(
    clk => clk,
    reset => reset,
    direction => direction,
    speed_sel => "11"
    );

drive_100MHz_clk: process
    begin
    clk <= '0';
    wait for PERIOD/2;
    clk <= '1';
    wait for PERIOD/2;
    end process;

change_directions:
    process
    begin
    direction <= std_logic_vector(unsigned(direction) + 1);
    wait for 1000000ns ;
    end process;

end Behavioral;
