library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity BCD_TO_SEVEN_SEGM is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           an_in : in STD_LOGIC_VECTOR (3 downto 0);
           g_to_a : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end BCD_TO_SEVEN_SEGM;

architecture Behavioral of BCD_TO_SEVEN_SEGM is

type t_segment_numerals_array is array (0 to 9) of STD_LOGIC_VECTOR (6 downto 0);
    constant c_numerals_0_to_9: t_segment_numerals_array := (
                               "1000000", -- 0
                               "1111001", -- 1
                               "0100100", -- 2
                               "0110000", -- 3
                               "0011001", -- 4
                               "0010010", -- 5
                               "0000010", -- 6
                               "1111000", -- 7
                               "0000000", -- 8
                               "0010000"); -- 9
                               
    constant c_e: STD_LOGIC_VECTOR (6 downto 0):= "0000110";
begin

    an <= not(an_in);  
    
process (x)
begin
    if unsigned(x) <10 then
        g_to_a <= c_numerals_0_to_9(to_integer(unsigned(x)));
    else
        g_to_a <= c_e; 
    end if;

end process;
            
end Behavioral;