library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity draw_components is
    Generic (
           hc_offset: integer:= 144;
           vc_offset: integer:= 35;
           component_width: integer:= 20
    );
    Port ( 
           clk: in std_logic;
           hc : in STD_LOGIC_vector(9 downto 0);
           vc : in STD_LOGIC_vector(9 downto 0);
           component_xy : in STD_LOGIC_vector(31 downto 0);
           is_draw: out std_logic);
end draw_components;

architecture Behavioral of draw_components is
    signal s_component_x: signed(15 downto 0);
    signal s_component_y: signed(15 downto 0);
    signal s_hc: signed(15 downto 0);
    signal s_vc: signed(15 downto 0);

begin

    s_component_x <= signed(component_xy(31 downto 16)) + hc_offset + (component_width/2);
    s_component_y <= signed(component_xy(15 downto 0 )) + vc_offset + (component_width/2);
    s_hc <= signed ("000000" & hc); -- make sure the vector is not interpreted as a negative
    s_vc <= signed ("000000" & vc); -- hc goes up to  800 where hc(9) is '1
    
    
    draw_component: process(clk, hc, vc)
         variable dx, dy             : signed(15 downto 0) := (others => '0');
    begin
        dx:= abs(s_hc - signed(s_component_x));
        dy:= abs(s_vc - signed(s_component_y));
        is_draw <= '0';
        if (dx < component_width/2 and dy < component_width/2) then 
            is_draw <= '1';
        end if;
    end process;
    

end Behavioral;
