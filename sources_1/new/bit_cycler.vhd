library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bit_cycler is
    port(
        clk: in std_logic;
        cycle_vector: out std_logic_vector(3 downto 0));
end bit_cycler;

architecture Behavioral of bit_cycler is
    signal signal_cycle_vector: std_logic_vector(3 downto 0);
begin

alternate: process(clk)
    begin
        if rising_edge(clk) then
            if signal_cycle_vector > "0000" and signal_cycle_vector /= "1000" then
                signal_cycle_vector <= signal_cycle_vector(2 downto 0) & "0";
            else
                signal_cycle_vector <= "0001";
        end if; 
        end if;
    end process;
    
    cycle_vector <= signal_cycle_vector;

end Behavioral;
