
-- Company: AP Hogeschool
-- Engineer: Jazzmin De Bie
-- Create Date: 09.08.2024 16:23:54
-- Module Name: top_snake - Behavioral
-- Project Name: Snake
-- Target Devices: Basys 3
-- Revision:
-- Revision 0.01 - File Created - ports and generics defined
-- Revision 0.02 - Seperated draw logic and apple functionality. Apple sometimes disapears (decrease max to screenwidth - block width)
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
    screen_width: integer:= 640;
    screen_height: integer:= 480;
--    border_width: integer;
--    apple_width: integer;
    head_width: integer:= 40;
    snake_length_max: integer:= 50;
    snake_begin_length: integer:= 0;
    snake_begin_x: integer:= 40;
    snake_begin_y: integer:= 40;
    food_begin_x: integer:= 120;
    food_begin_y: integer:=120
    );
    
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
    score_p1: out unsigned (15 downto 0);
               --score_p2: out unsigned (15 downto 0);
               
    is_body: out std_logic;
    is_head: out std_logic;
    is_apple: out std_logic);
    
end game_logic;

architecture Behavioral of game_logic is

    component move_snake is
        Generic (   
                snake_begin_pos_x: integer := snake_begin_x;
                snake_begin_pos_y: integer := snake_begin_y;
                head_width: integer := head_width;
                screen_width: integer := screen_width;
                screen_height: integer := screen_height;
                snake_length_max: integer := snake_length_max
                );
        Port ( clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                direction : in STD_LOGIC_VECTOR (1 downto 0);
                head_xy : out std_logic_vector(31 downto 0);
                snake_body_xy: out xys (0 to snake_length_max - 1);
                hit_border: out std_logic;
                speed_sel: in std_logic_vector(1 downto 0)
                );
    end component;
    
    component random_number_gen is
        Generic(
            max: integer := 640;
            step: integer := head_width);
        Port (
            clk: in std_logic;
            random_number: out std_logic_vector(15 downto 0));
    end component;
    
    component draw_components is
    Generic (
           hc_offset: integer:= 144;
           vc_offset: integer:= 35;
           component_width: integer:= head_width
    );
    Port ( 
           clk: in std_logic;
           hc : in STD_LOGIC_vector(9 downto 0);
           vc : in STD_LOGIC_vector(9 downto 0);
           component_xy : in STD_LOGIC_vector(31 downto 0);
           is_draw: out std_logic);
    end component;
    
    component draw_xys is
    Generic (
        component_xys_length: integer := snake_length_max;
        hc_offset: integer:= 144;
        vc_offset: integer:= 35;
        component_width: integer:= head_width);
    Port ( 
           clk: in std_logic;
           hc : in STD_LOGIC_vector(9 downto 0);
           vc : in STD_LOGIC_vector(9 downto 0);
           component_xys : in xys (0 to component_xys_length -1 );
           valid_length: in unsigned (15 downto 0);
           is_draw: out std_logic);
    end component;
    
    signal head_xy_p1: std_logic_vector(31 downto 0);
    signal apple_xy: std_logic_vector(31 downto 0);
    signal food_xy: std_logic_vector(31 downto 0);
    signal rand_xy: std_logic_vector(31 downto 0);
    signal u_score_p1: unsigned(15 downto 0);
    signal u_snake_length: unsigned(15 downto 0);
    signal snake_body_xy: xys (0 to snake_length_max -1);
    signal hit_border_p1: std_logic; 
    --signal inited: std_logic:= '0';
    signal reset_snake: std_logic;

begin
    
    set_food: process(reset, clk, food_xy, head_xy_p1, border_enable, hit_border_p1)
        variable dx, dy : signed (15 downto 0);
        variable inited: std_logic:= '0';
    begin
        dx := abs(signed(food_xy(31 downto 16)) - signed(head_xy_p1(31 downto 16)));
        dy := abs(signed(food_xy(15 downto 0)) - signed(head_xy_p1(15 downto 0)));
        reset_snake <= '0';
        if reset = '1' or inited = '0' then 
            food_xy (31 downto 16) <= std_logic_vector(to_unsigned(food_begin_x, 16));
            food_xy (15 downto 0) <= std_logic_vector(to_unsigned(food_begin_y, 16));
            u_score_p1 <= to_unsigned(0, 16);
            u_snake_length <= to_unsigned(snake_begin_length, 16);
--            reset_snake <= '1';
            inited:='1';
        
        elsif rising_edge(clk) then
            reset_snake <= '0';
            if border_enable = '1' and hit_border_p1 ='1' then
                inited:='0';
            end if;
            
            -- snake head hits food
            if (dx < head_width/2 and dy < head_width/2) then 
                food_xy <= rand_xy;
                if u_snake_length < snake_length_max - 1 then
                    u_snake_length <= u_snake_length + 1;  
                end if;
                u_score_p1 <= u_score_p1 +1;
            end if; 
            
            for i in snake_length_max - 1 downto 1 loop
            dx := abs(signed(head_xy_p1(31 downto 16)) - signed(snake_body_xy(i)(31 downto 16)));
            dy := abs(signed(head_xy_p1(15 downto 0))  - signed(snake_body_xy(i)(15 downto 0)));
                if(i<=u_snake_length)then
                    if(dx<head_width and dy<head_width)then
                        inited:='0';
                    end if;
                end if;
            end loop;
              
        end if;

    end process;
   

    move_snake_p1_component: move_snake
    Port map( clk => clk,
           reset =>   reset_snake,
           direction => direction_p1,
           head_xy => head_xy_p1,
           snake_body_xy => snake_body_xy,
           hit_border => hit_border_p1,
           speed_sel => speed_sel);
           
    draw_head: draw_components
    Port map( 
           clk => clk,
           hc => hcount,
           vc => vcount,
           component_xy => head_xy_p1,
           is_draw => is_head
    );
    
    draw_food: draw_components
    Port map( 
           clk => clk,
           hc => hcount,
           vc => vcount,
           component_xy => food_xy,
           is_draw => is_apple
    );
    
    draw_body: draw_xys
    Port map(
        clk => clk,
        hc => hcount,
        vc => vcount,
        component_xys => snake_body_xy,
        valid_length => u_snake_length,
        is_draw => is_body
        );
    
    
    rand_x_generator: random_number_gen
    generic map (max => screen_width - head_width, 
                step => head_width)
    port map ( 
        clk => clk,
        random_number => rand_xy(31 downto 16) );
    
    rand_y_generator: random_number_gen
    generic map (max => screen_height - head_width,
                step => head_width)
    port map ( 
        clk => clk,
        random_number => rand_xy (15 downto 0));   
                         
    score_p1 <= u_score_p1;

end Behavioral;

