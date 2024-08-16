library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity random_number_gen is
Generic(
    max: integer := 640;
    step: integer := 20
);
Port (
    clk: in std_logic;
    random_number: out std_logic_vector(15 downto 0)
);
    
end random_number_gen;

architecture Behavioral of random_number_gen is

    signal s_random_number: unsigned(15 downto 0) := (others => '0');

begin

process (clk)
begin
    if rising_edge(clk) then
        if s_random_number >= to_unsigned(max, 16) then
            s_random_number <= (others => '0');
        else
            s_random_number <= s_random_number + to_unsigned(step, 16); -- must be inside else statement otherwise checked simultaneous and never eq max
        end if;                            
    end if;
end process;

random_number <= std_logic_vector(s_random_number);

end Behavioral;



