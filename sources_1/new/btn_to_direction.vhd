library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity btn_to_direction is
Port (
    clk: in std_logic;
    btnU, btnD, btnL, btnR: in std_logic;
    current_direction: in std_logic_vector (1 downto 0);
    new_direction: out std_logic_vector (1 downto 0)
    );
end btn_to_direction;

architecture Behavioral of btn_to_direction is

    signal direction: std_logic_vector(1 downto 0):= "00";
    signal btns: std_logic_vector(3 downto 0);           -- U L R D
    signal prev_btns: std_logic_vector(3 downto 0):= "0000";      --necessary to detect button release

begin

btns <= btnU & btnL & btnR & btnD;
process (btnU, btnD, btnL, btnR, current_direction, clk)
begin
    if rising_edge(clk) then
        -- if button wasn't pressed previously and is pressed while the opposite direction isn't active , assign button
        -- up
        if prev_btns(3) = '0' and btns(3) = '1'  and (current_direction /= "11") then
            direction <= "00";
        -- left
        end if;
        if prev_btns(2) = '0' and btns(2) = '1'  and (current_direction /= "10") then
            direction <= "01";
        end if;
        -- right
        if prev_btns(1) = '0' and btns(1) = '1'  and (current_direction /= "01") then
            direction <= "10";
        -- down
        end if;
        if prev_btns(0) = '0' and btns(0) = '1'  and (current_direction /= "00") then
            direction <= "11";
        end if;
        prev_btns <= btns;
    end if;
    
end process;

new_direction <= direction;


end Behavioral;
