library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity score_board is
    Port ( clk_500Hz : in STD_LOGIC; -- 4kHz to 170Hz for best results
           score : in unsigned (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0); 
           an : out STD_LOGIC_VECTOR (3 downto 0));
end score_board;

architecture Behavioral of score_board is

    component bit_cycler
        port(clk: in std_logic;
            cycle_vector: out std_logic_vector(3 downto 0));
    end component;

    component BCD_TO_SEVEN_SEGM
        Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
               an_in : in STD_LOGIC_VECTOR (3 downto 0);
               g_to_a : out STD_LOGIC_VECTOR (6 downto 0);
               an : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component unsigned_to_bcd is
        Port ( unsigned_score : in unsigned (15 downto 0);
               bcd: out std_logic_vector(15 downto 0));
    end component;

    signal signal_an: STD_LOGIC_VECTOR (3 downto 0);
    signal bcd: std_logic_vector(15 downto 0);
    signal digit_bcd: std_logic_vector(3 downto 0);

begin
    score_conversion: unsigned_to_bcd
    port map(score, bcd);
    
    display_driver: BCD_TO_SEVEN_SEGM
        Port map( x => digit_BCD,
                 an_in => signal_an,
                 g_to_a => seg,
                 an => an);
    
    display_alternator: bit_cycler
        port map( clk => clk_500Hz,
                  cycle_vector => signal_an);
    -- assign the active digit
    digit_BCD <=    BCD( 3 downto  0) when signal_an = "0001" else
                    BCD( 7 downto  4) when signal_an = "0010" else
                    BCD(11 downto  8) when signal_an = "0100" else
                    BCD(15 downto 12); -- "1000"

end Behavioral;
