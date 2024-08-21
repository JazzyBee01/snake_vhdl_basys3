library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;


entity PS2_direction is
    Generic (
        scan_code_00: std_logic_vector(7 downto 0);
        scan_code_01: std_logic_vector(7 downto 0); 
        scan_code_10: std_logic_vector(7 downto 0);
        scan_code_11: std_logic_vector(7 downto 0)
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (7 downto 0);
           valid : in STD_LOGIC;
           current_direction : in STD_LOGIC_VECTOR (1 downto 0);
           new_direction : out STD_LOGIC_VECTOR (1 downto 0)
           );

end PS2_direction;

architecture Behavioral of PS2_direction is
    signal prev_valid, flag: std_logic; 
    signal direction: std_logic_vector (1 downto 0);
    
begin
    process (clk, rst, current_direction) begin 
        if rst = '1' then 
            flag <= '0'; 
            direction <= "00";   
    
        elsif rising_edge (clk)then 
            prev_valid <= valid;  
            if (prev_valid = '1' and valid = '0') then   
    --push key the first time check data at falling edge
                
                if (data = x"F0") then -- scan code for key release
                    flag <= '1';
                else
                    if (data = scan_code_00) and current_direction /= "11" then
                        direction <= "00";
                    elsif (data = scan_code_01) and current_direction /= "10" then
                        direction <= "01";
                    elsif (data = scan_code_10) and current_direction /= "01" then
                        direction <= "10";
                    elsif (data = scan_code_11) and current_direction /= "00" then
                        direction <= "11";
                    else
                        direction <= current_direction;
                    end if;
                    flag <= '0';
                end if;  
            end if;
        end if;    
    end process;
    
    new_direction <= direction;
    
end Behavioral;

