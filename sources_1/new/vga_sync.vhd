library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity vga_sync is
    Port ( clk_25MHz : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : out std_logic; 
           vsync : out std_logic; 
           hc : out std_logic_vector(9 downto 0); -- max 800 => 0011 0010 0000
           vc : out std_logic_vector(9 downto 0); -- max 525 => 0010 0000 1101
           vidon : out std_logic );
end vga_sync;

architecture Behavioral of vga_sync is
    -- constants for 640x480@60Hz
    -- source: http://www.tinyvga.com/vga-timing/640x480@60Hz 
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
                                                      -- same as V_LINES - V_FP
        if in_h_area and in_v_area then
            vidon <= '1';
        else
            vidon <= '0'; 
        end if;
    end process;
    
    HC <= std_logic_vector(to_unsigned(hcs, 10));
    VC <= std_logic_vector(to_unsigned(vcs, 10));

end Behavioral;