----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.08.2024 15:13:46
-- Design Name: 
-- Module Name: game_logic - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created----------------------------------------------------------------------------------
-- Company: AP Hogeschool
-- Engineer: Jazzmin De Bie
-- Create Date: 09.08.2024 16:23:54
-- Module Name: top_snake - Behavioral
-- Project Name: Snake
-- Target Devices: Basys 3
-- Revision:
-- Revision 0.01 - File Created - ports and generics defined
-- Additional Comments:
--  used https://github.com/pikachu32/snake_vhdl/blob/main/game_logic.vhd as a reference
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common.ALL;

entity game_logic is
Generic(
--    screen_width: integer;
--    screen_height: integer;
--    border_width: integer;
--    apple_width: integer;
    head_width: integer:= 20;
--    snake_max_length: integer;
--    snake_begin_length: integer;
--    snake_begin_x: integer;
--    snake_begin_y: integer;
    food_begin_x: integer:= 100;
    food_begin_y: integer:=100);
    
Port (
    clk: in std_logic;
    reset: in std_logic;
    hcount: in std_logic_vector(9 downto 0); -- could require conversion for vga_sync
    vcount: in  std_logic_vector(9 downto 0);
    vidon: in std_logic;
    
    -- settings
            -- game_2_players_en: in std_logic;
    speed_sel: in std_logic_vector(1 downto 0);
    border_enable: in std_logic;
    
    -- controls
    direction_p1: in std_logic_vector(1 downto 0);
                -- direction_p2: in std_logic_vector(1 downto 0);
    -- outputs
    socre_p1: out unsigned (15 downto 0);
               --score_p2: out unsigned (15 downto 0);
               
    is_body: out std_logic;
    is_head: out std_logic;
    is_apple: out std_logic;
    
    food: out std_logic_vector (31 downto 0)
    
 );
end game_logic;

architecture Behavioral of game_logic is

    component move_snake is
        Generic (   
                snake_begin_pos_x: integer := 20;
                snake_begin_pos_y: integer := 20;
                head_width: integer := 20;
                screen_width: integer := 640;
                screen_height: integer := 480
                );
        Port ( clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                direction : in STD_LOGIC_VECTOR (1 downto 0);
                head_xy : out std_logic_vector(31 downto 0)
                );
    end component;
    
    component random_number_gen is
        Generic(
            max: integer := 640
        );
        Port (
            clk: in std_logic;
            random_number: out std_logic_vector(15 downto 0)
        );
    
    end component;
    
    component draw_components is
    Generic (
           hc_offset: integer:= 144;
           vc_offset: integer:= 35;
           head_width: integer:= 20
    );
    Port ( 
           clk: in std_logic;
           hc : in STD_LOGIC_vector(9 downto 0);
           vc : in STD_LOGIC_vector(9 downto 0);
           head_xy : in STD_LOGIC_vector(31 downto 0);
           is_body: out std_logic;
           is_head: out std_logic;
           is_apple: out std_logic);
    end component;
    
signal head_xy_p1: std_logic_vector(31 downto 0);
signal apple_xy: std_logic_vector(31 downto 0);
signal food_xy: std_logic_vector(31 downto 0);
signal rand_xy: std_logic_vector(31 downto 0);

begin

    move_snake_p1_component: move_snake

    Port map( clk => clk,
           reset =>   reset,
           direction => direction_p1,
           head_xy => head_xy_p1 );
           
    draw: draw_components
    Port map( 
           clk => clk,
           hc => hcount,
           vc => vcount,
           head_xy => head_xy_p1,
           is_body => is_body,
           is_head => is_head) ;
           
    set_food: process(reset, clk, food_xy, head_xy_p1)
        variable dx, dy : signed (15 downto 0);
    begin
        dx := abs(signed(food_xy(31 downto 16)) - signed(head_xy_p1(31 downto 16)));
        dy := abs(signed(food_xy(15 downto 0)) - signed(head_xy_p1(15 downto 0)));
        
        if reset = '1' then
            food_xy (31 downto 16) <= std_logic_vector(to_unsigned(food_begin_x, 16));
            food_xy (15 downto 0) <= std_logic_vector(to_unsigned(food_begin_y, 16));
        elsif rising_edge(clk) then
            if (dx < head_width/2 and dy < head_width/2) then 
                food_xy <= rand_xy;
            end if;
            
        end if;
    end process;
    
    rand_x_generator: random_number_gen
    generic map (
        max => 640)
    port map ( 
        clk => clk,
        random_number => rand_xy(31 downto 16) 
    );
    
    rand_y_generator: random_number_gen
    generic map (
        max => 480)
    port map ( 
        clk => clk,
        random_number => rand_xy (15 downto 0) 
    );
    
    food <= food_xy;
        
        
            
            
        


end Behavioral;

