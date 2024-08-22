library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_unsigned_to_bcd is
--  Port ( );
end TB_unsigned_to_bcd;

architecture Behavioral of TB_unsigned_to_bcd is

component unsigned_to_bcd is
    Port ( unsigned_score : in unsigned (15 downto 0);
           bcd: out std_logic_vector(15 downto 0));
end component;

type bcd_array is array (0 to 3) of std_logic_vector(3 downto 0);
signal score: unsigned(15 downto 0);
signal bcd: std_logic_vector(15 downto 0);
signal bcd_split: bcd_array;

begin
    DUT: unsigned_to_bcd
    port map(score, bcd);

    score_counter: process
    begin
        if score < 9999 then
            score <= score + 1;
        else
            score <= (others => '0');
        end if;
        wait for 10ns;
    end process;
    
    bcd_split(3) <= bcd(15 downto 12);
    bcd_split(2) <= bcd(11 downto 8);
    bcd_split(1) <= bcd(7  downto 4);
    bcd_split(0) <= bcd(3  downto 0);

end Behavioral;
