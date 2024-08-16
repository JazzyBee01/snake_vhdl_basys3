library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity vga_sync is
    Port ( clk_25MHz : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : out std_logic; 
           vsync : out std_logic; 
           hc : out std_logic_vector(9 downto 0); 
           vc : out std_logic_vector(9 downto 0); 
           vidon : out std_logic );
end vga_sync;

architecture Behavioral of vga_sync is
constant H_LINES:   integer := 800;
constant H_FP:      integer := 16;
constant H_SYNC:    integer := 96;
constant H_BP:      integer := 48;
constant H_ACTIVE:   integer := 640;

constant V_LINES:   integer := 525;
constant V_FP:      integer := 10;
constant V_BP:      integer := 33;
constant V_SYNC:    integer := 2;
constant V_ACTIVE:   integer := 480;

signal hcs: integer:= 0;
signal vcs: integer:= 0;

begin

        Hcounter: process (clk_25MHz) is
        begin
            if rising_edge (clk_25MHz) then
                if hcs = H_LINES then
                    hcs <= 0;  
                else
                    hcs <= hcs +1;
                end if;
            end if; 
        end process;
        
        Vcounter: process (clk_25MHz) is 
        begin
            if rising_edge (clk_25MHz) then
                if HCs = H_LINES then
                    if VCs = V_LINES then 
                        VCs <= 0;
                    else
                        VCs <= VCs + 1;
                    end if;
                end if;
            end if;
        end process;
        
        Hsyncp: process (HCs)
        begin
            if  HCs < H_SYNC then
                Hsync <= '0';
            else
                Hsync <= '1';
            end if;
        end process;
        
        Vsyncp: process (VCs)
        begin
            if VCs < V_SYNC then       -- sync pulse = 2 lines
                Vsync <= '0';
            else
                Vsync <= '1';
            end if;
        end process;
        
        inzichtbaargebied: process (VCs, HCs) is
            variable in_h_area, in_v_area: boolean;
        begin
            in_h_area := (H_SYNC + H_BP) <= HCs and HCs < (H_SYNC + H_BP + H_ACTIVE);
            in_v_area := (V_SYNC + V_BP) <= VCs and VCs < (V_SYNC + V_BP + V_ACTIVE);
            if in_h_area and in_v_area then
                vidon <= '1';
            else
                vidon <= '0'; 
            end if;
        end process;
        
        HC <= std_logic_vector(to_unsigned(hcs, 10));
        VC <= std_logic_vector(to_unsigned(vcs, 10));

end Behavioral;



--constant hpixels: std_logic_vector(9 downto 0) := "1100100000"; 
-- --Value of pixels in a horizontal line = 800 
--constant vlines: std_logic_vector(9 downto 0) := "1000001001";    
-- --Number of horizontal lines in the display = 521 
--constant hbp: std_logic_vector(9 downto 0) := "0010010000";   
-- --Horizontal back porch = 144 (128+16) 
--constant hfp: std_logic_vector(9 downto 0) := "1100010000";   
-- --Horizontal front porch = 784 (128+16+640) 
--constant vbp: std_logic_vector(9 downto 0) := "0000100011";   
-- --Vertical back porch = 31 (2+29) -- NEE = 35 ( 2 + 33 )
--constant vfp: std_logic_vector(9 downto 0) := "0111111111";   
-- --Vertical front porch = 511 (2+29+480) 
--signal hcs, vcs: std_logic_vector(9 downto 0);     
--     --These are the Horizontal and Vertical counters 
--signal vsenable: std_logic;      
-- --Enable for the Vertical counter
--begin
----Counter for the horizontal sync signal 
--   process(clk_25MHz, clr) 
--   begin 
--    if clr = '1' then 
--     hcs <= "0000000000"; 
--    elsif(clk_25MHz'event and clk_25MHz = '1') then 
--     if hcs = hpixels - 1 then  --The counter has reached the end of pixel count 
--   hcs <= "0000000000"; --reset the counter 
--   vsenable <= '1';  --Enable the vertical counter  
--     else 
--   hcs <= hcs + 1;  --Increment the horizontal counter 
--   vsenable <= '0';  --Leave the vsenable off 
--     end if; 
--    end if; 
--   end process; 
 
--   hsync <= '0' when hcs < 96 else '1'; --Horizontal Sync Pulse is low when hc is 0 - 96 
   
-- --Counter for the vertical sync signal 
-- process(clk_25MHz, clr, vsenable) 
-- begin 
--       if clr = '1' then 
--  vcs <= "0000000000"; 
--       elsif(clk_25MHz'event and clk_25MHz = '1' and vsenable='1') then 
--         --Increment when enabled 
--  if vcs = vlines - 1 then  --Reset when the number of lines is reached 
--      vcs <= "0000000000"; 
--  else  
--   vcs <= vcs + 1;  --Increment vertical counter 
--  end if; 
--       end if; 
-- end process; 
 
-- vsync <= '0' when vcs < 2 else '1';  --Vertical Sync Pulse is low when vc is 0 or 1 
   
-- --Enable video out when within the porches 
-- vidon <= '1' when (((hcs < hfp) and (hcs >= hbp))  
--                   and ((vcs < vfp) and (vcs >= vbp))) else '0';  
 

-- -- output horizontal and vertical counters 
-- hc <= hcs; 
-- vc <= vcs;