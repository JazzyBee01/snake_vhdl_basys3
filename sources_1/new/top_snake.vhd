----------------------------------------------------------------------------------
-- Company: AP Hogeschool
-- Engineer: Jazzmin De Bie
-- 
-- Create Date: 08.08.2024 17:52:27
-- Module Name: Top_snake - Behavioral
-- Project Name: Snake
-- Target Devices: Basys3
-- Tool Versions: Vivado 2019.2
-- Description: 
--      The top level of snake for Basys3
--      VGA is driven at 640x480@60Hz

--     Configuration
--        SW(15) enables on board button controls
--        SW(14) enables a border. Snake is wrapped around screen
--        when border is disabled
--        SW(1:0) sets the speed of the snake
--            "00" => 1Hz
--            "01" => 2Hz
--            "10" => 4Hz
--            "11" => 8Hz
--     Controls
--        when SW(15) = '1' use the buttons on the basys3 to control the snake
--        else use QSDZ or ASDW on a USB keyboard

-- Additional Comments:
--    This project  was originally intended to have a 2-player breakout variant. Remenants of this can be found.
--    Idea was canceled due to limit on LUT's and time.
    
--    The current snake_length_max is less than the amount of possible blocks on the screen
--    This is also due to a limit in LUT's. 
--    an alternative way of tracking the body should be used if the project is to be expanded. 
        
----------------------------------------------------------------------------------

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
    
    component clkdiv is 
    generic(
        division: integer:= 4);
    port( 
        clk : in STD_LOGIC; 
        clr : in STD_LOGIC; 
        slow_clk : out STD_LOGIC ); 
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
        hcount: in std_logic_vector(9 downto 0);
        vcount: in  std_logic_vector(9 downto 0);
        vidon: in std_logic;
        speed_sel: in std_logic_vector(1 downto 0);
        border_enable: in std_logic;
        direction_p1: in std_logic_vector(1 downto 0);
        score_p1: out unsigned (15 downto 0);
        is_body: out std_logic;
        is_head: out std_logic;
        is_apple: out std_logic
    );
    end component;
    
    component score_board is
    Port ( clk_500Hz : in STD_LOGIC;
           score : in unsigned (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
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
    signal clk_500Hz: std_logic;
    signal vidon: std_logic;
    signal hc: std_logic_vector(9 downto 0);
    signal vc: std_logic_vector(9 downto 0);
    signal is_head: std_logic;
    signal is_body: std_logic;
    signal is_apple: std_logic;
    signal direction: std_logic_vector(1 downto 0);
    signal score_p1:  unsigned (15 downto 0);

begin

    clk_div_25MHz: clkdiv -- for VGA
    generic map (
        division => 4)
    port map (
        clk => clk,
        clr => '0',
        slow_clk => clk_25MHz);
            
    clk_div_500Hz: clkdiv -- for seven segm
    generic map (
        division => 200000)
    port map (
        clk => clk,
        clr => '0',
        slow_clk => clk_500Hz);
          
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
        is_body => is_body,
        is_food => is_apple,
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
    
    score_control: score_board
    port map(
        clk_500Hz => clk_500Hz,
        score => score_p1,
        seg => seg,
        an => an);
    
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
        is_apple => is_apple, 
        score_p1 => score_p1
    );
     
    led(1 downto 0) <= direction;

end Behavioral;