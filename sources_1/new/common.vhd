library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Common is
    subtype xy is std_logic_vector(31 downto 0); 
    type xys is array (integer range <>) of xy;
end package Common;

package body Common is
   -- subprogram bodies here
end Common;
