library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common.all;

entity move_snake is
    Generic (   snake_begin_pos_x: integer := 20;
                snake_begin_pos_y: integer := 20;
                head_width: integer := 20;
                screen_width: integer := 640;
                screen_height: integer := 480;
                snake_length_max: integer:= 100
                );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           direction : in STD_LOGIC_VECTOR (1 downto 0);
           head_xy : out std_logic_vector (31 downto 0);
           snake_body_xy: out xys (0 to snake_length_max - 1)
           );
end move_snake;

architecture Behavioral of move_snake is

signal count: integer:= 0;
signal delay: integer:= 100000000;
signal s_head_x: unsigned(15 downto 0);
signal s_head_y: unsigned(15 downto 0);
signal u_screen_width: unsigned(15 downto 0) := to_unsigned(screen_width, 16);
signal u_screen_height: unsigned(15 downto 0) := to_unsigned(screen_height, 16);
signal u_head_width: unsigned(15 downto 0) := to_unsigned(head_width, 16);
signal s_snake_body_xy: xys (0 to snake_length_max - 1);

    
begin

move_snake: process(reset, clk, direction)

    begin
        if reset = '1' then
            s_head_x <= to_unsigned(snake_begin_pos_x, 16);
            s_head_y <= to_unsigned(snake_begin_pos_y, 16);
            for i in 0 to snake_length_max - 1 loop
                s_snake_body_xy(i) <= std_logic_vector(s_head_x) & std_logic_vector(s_head_y);
            end loop;
            
        elsif rising_edge(clk) then
            count <= count + 1;
            if (count >= delay) then
            count <= 0;
            case direction is
                when "00" => -- Up
                    if s_head_y >= u_head_width then
                        s_head_y <= s_head_y - u_head_width;
                    else
                        s_head_y <= u_screen_height - u_head_width; -- Wrap around
                    end if;
                when "11" => -- Down
                    if s_head_y + u_head_width < u_screen_height then
                        s_head_y <= s_head_y + u_head_width;
                    else
                        s_head_y <= (others => '0'); -- Wrap around to 0
                    end if;
                when "01" => -- Left
                    if s_head_x >= u_head_width then
                        s_head_x <= s_head_x - u_head_width;
                    else
                        s_head_x <= u_screen_width - u_head_width; -- Wrap around
                    end if;
                when "10" => -- Right
                    if s_head_x + u_head_width < u_screen_width then
                        s_head_x <= s_head_x + u_head_width;
                    else
                        s_head_x <= (others => '0'); -- Wrap around to 0
                    end if;
                when others =>
                    null;
            end case;
            -- update body
            for i in 1 to snake_length_max - 1 loop
                s_snake_body_xy(i) <= s_snake_body_xy(i-1);
            end loop;
            s_snake_body_xy(0) <= std_logic_vector(s_head_x) & std_logic_vector(s_head_y);
            
            
            end if;
        end if;
    end process;
    
head_xy <= std_logic_vector(s_head_x) & std_logic_vector(s_head_y);
snake_body_xy <= s_snake_body_xy;



end Behavioral;
