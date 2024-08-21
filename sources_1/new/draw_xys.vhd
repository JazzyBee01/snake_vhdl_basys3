library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common.all;

entity draw_xys is
    Generic (
        component_xys_length: integer := 15;
        hc_offset: integer:= 144;
        vc_offset: integer:= 35;
        component_width: integer:= 20
    );
    
    Port ( 
           clk: in std_logic;
           hc : in STD_LOGIC_vector(9 downto 0);
           vc : in STD_LOGIC_vector(9 downto 0);
           component_xys : in xys (0 to component_xys_length -1 );
           valid_length: in unsigned (15 downto 0);
           is_draw: out std_logic);
end draw_xys;

architecture Behavioral of draw_xys is

signal is_draw_array : std_logic_vector(0 to component_xys_length-1):= (others => '0');
constant empty_array  : std_logic_vector (0 to component_xys_length -1) := (others => '0');

begin

    gen_body_draw_blocks: for i in 0 to component_xys_length - 1 generate
        body_draw_block: entity work.draw_components 
            generic map (
                hc_offset => hc_offset,
                vc_offset => vc_offset,
                component_width => component_width
                )
            port map (
            clk => clk,
            hc => hc,
            vc => vc,
            component_xy => component_xys(i),
            is_draw => is_draw_array(i)
        );
    end generate gen_body_draw_blocks;
    
        -- OR all the is_body signals together
    
    is_draw <= '0' 
    when is_draw_array(0 to to_integer(valid_length)) = empty_array(0 to to_integer(valid_length))
    else '1';


end Behavioral;
