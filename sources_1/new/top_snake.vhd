library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.common.ALL;

entity top_snake is
Port (  clk: in std_logic;
        -- inputs
        clr : in STD_LOGIC;
        PS2Data : in STD_LOGIC;
        PS2Clk : in STD_LOGIC;
        sw: in std_logic_vector(15 downto 0); -- 2 player game - border en - speed sel;
        btnU : in STD_LOGIC;
        btnD : in STD_LOGIC;
        btnL : in STD_LOGIC;
        btnR : in STD_LOGIC;
        -- VGA
        Hsync : out std_logic; 
        Vsync : out std_logic;
        vgaRed: out std_logic_vector( 3 downto 0);
        vgaGreen: out std_logic_vector( 3 downto 0);
        vgaBlue: out std_logic_vector( 3 downto 0);
        -- seven-segm display
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0);
        
        led: out std_logic_vector (15 downto 0)
        );
   
        
end top_snake;

architecture Behavioral of top_snake is

    component clk_wiz_0 is
        Port ( clk_in1 : in STD_LOGIC; 
            clk_out1: out STD_LOGIC);
    end component;
    
    component vga_sync is
    Port ( clk_25MHz : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : out std_logic; 
           vsync : out std_logic; 
           hc : out std_logic_vector(9 downto 0); 
           vc : out std_logic_vector(9 downto 0); 
           vidon : out std_logic );
    end component;
    
    component controls is
    Port (
        clk : in STD_LOGIC;
        clr : in STD_LOGIC;
        button_en: in STD_LOGIC;
        PS2Data : in STD_LOGIC;
        PS2Clk : in STD_LOGIC;
        btnU, btnD, btnL, btnR: in std_logic;
        direction_p1, direction_p2: out std_logic_vector (1 downto 0));
    end component;
    
    component game_logic is
    Port (
    clk: in std_logic;
    reset: in std_logic;
    hcount: in std_logic_vector(9 downto 0); -- could require conversion for vga_sync
    vcount: in  std_logic_vector(9 downto 0);
    vidon: in std_logic;
    speed_sel: in std_logic_vector(1 downto 0);
    border_enable: in std_logic;
    direction_p1: in std_logic_vector(1 downto 0);
    socre_p1: out unsigned (15 downto 0);
    is_body: out std_logic;
    is_head: out std_logic;
    is_apple: out std_logic
    );
    end component;
    
    
    component draw
    Port ( 
        vidon: in std_logic;
        is_body: in std_logic;
        is_food: in std_logic;
        is_head: in std_logic;
        vgaRed: out std_logic_vector( 3 downto 0);
        vgaGreen: out std_logic_vector( 3 downto 0);
        vgaBlue: out std_logic_vector( 3 downto 0)
    );
    end component;
   
    signal clk_25MHz: std_logic;
    signal vidon: std_logic;
    signal hc: std_logic_vector(9 downto 0);
    signal vc: std_logic_vector(9 downto 0);
    signal is_head: std_logic;
    signal is_body: std_logic;
    signal is_apple: std_logic;
    signal direction: std_logic_vector(1 downto 0);

begin

    clk_25MHz_gen: clk_wiz_0
        Port map(   
            clk_in1 => clk,
            clk_out1 => clk_25MHz);
            
    U2: vga_sync
    port map (  
        clk_25MHz => clk_25MHz,
        clr => clr,
        hsync => Hsync,
        vsync => Vsync,
        vidon => vidon,
        hc => hc,
        vc => vc
     );
     
    U3: draw 
    port map(
        vidon => vidon,
        is_body => sw(0),
        is_food => sw(1),
        is_head => is_head,
        vgaRed => vgaRed,
        vgaGreen => vgaGreen,
        vgaBlue => vgaBlue
    );
    
    control_component: controls
    Port map(
        clk => clk,
        clr => clr,
        button_en => sw(15),
        PS2Data => PS2Data,
        PS2Clk => PS2Clk,
        btnU => btnU,
        btnD => btnD,
        btnL => btnL,
        btnR => btnR,
        direction_p1 => direction
--        direction_p2 => led(1 downto 0)
    );
    
    game_logic_component: game_logic
    port map(
        clk => clk,
        reset => clr,  
        hcount => hc,  
        vcount => vc,  
        vidon => vidon, 
        speed_sel => sw(1 downto 0),  
        border_enable => sw(14), 
        direction_p1 => direction,  
        is_body => is_body,  
        is_head => is_head, 
        is_apple => is_apple  
    );
    
    
    led(1 downto 0) <= direction;
    



end Behavioral;