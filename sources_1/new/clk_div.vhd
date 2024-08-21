library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_unsigned.all; 

entity clkdiv is 
  generic(
    division: integer:= 4 -- for 25Mhz 
  );
  port( 
   clk : in STD_LOGIC; 
   clr : in STD_LOGIC; 
   slow_clk : out STD_LOGIC 
      ); 
end clkdiv; 


 
architecture behavioral of clkdiv is 
signal q: integer range 0 to 100000000;
signal slowclock: std_logic:= '0';

begin 
   
process(clk, clr) 
  begin 
    if clr = '1' then 
        q <= 0; 
        slowclock <= '0';
    elsif rising_edge (clk) then 
        q <= q + 1; 
        if (q = division/2 -1) then
            slowclock <= not slowclock;
            q <= 0;
        end if;
    end if; 
  end process; 
  -- only adding on the rising edge makes q(0) already half the frequency of clk in 
  slow_clk <= slowclock;
   
end behavioral; 