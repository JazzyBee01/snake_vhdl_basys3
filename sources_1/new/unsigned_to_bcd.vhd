library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity unsigned_to_bcd is
    Port ( unsigned_score : in unsigned (15 downto 0);
           bcd: out std_logic_vector(15 downto 0));
end unsigned_to_bcd;

architecture Behavioral of unsigned_to_bcd is

--signal e3, e2, e1, e0: integer:= 0;
begin
    convert: process(unsigned_score)
        variable score_int: integer;
        variable e3, e2, e1, e0: integer:= 0;
    begin
        score_int := to_integer(unsigned_score);
        e3 := score_int/1000;
        e2 := (score_int - (e3 * 1000))/100;
        e1 := (score_int - (e3 * 1000) - (e2 * 100))/10;
        e0 := (score_int - (e3 * 1000) - (e2 * 100) - (e1*10));
        
    bcd(15 downto 12) <= std_logic_vector(to_unsigned(e3, 4));
    bcd(11 downto 8) <= std_logic_vector(to_unsigned(e2, 4));
    bcd(7 downto 4) <= std_logic_vector(to_unsigned(e1, 4));
    bcd(3 downto 0) <= std_logic_vector(to_unsigned(e0, 4));
 
    end process;
    


end Behavioral;
