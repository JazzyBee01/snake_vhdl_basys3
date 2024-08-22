library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controls is
Port (
    clk : in STD_LOGIC;
    clr : in STD_LOGIC;
    button_en: in std_logic; -- switch between buttons and keyboard for p1 1 => buttons
    PS2Data : in STD_LOGIC;
    PS2Clk : in STD_LOGIC;
    btnU, btnD, btnL, btnR: in std_logic;
    direction_p1, direction_p2: out std_logic_vector (1 downto 0)
    );
end controls;

architecture Behavioral of controls is
    component PS2
    port (
        clk : in STD_LOGIC;
        clr : in STD_LOGIC;
        ps2d : in STD_LOGIC;
        ps2c : in STD_LOGIC;
        ps2_new : out STD_LOGIC;
        ps2_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;
    
    component PS2_direction is
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
    end component;
    
    component btn_to_direction is
    Port (
        clk: in std_logic;
        btnU, btnD, btnL, btnR: in std_logic;
        current_direction: in std_logic_vector (1 downto 0);
        new_direction: out std_logic_vector (1 downto 0)
        );
    end component;
    
    signal ps2_out: STD_LOGIC_VECTOR (7 downto 0);
    signal ps2_valid: STD_LOGIC;
    signal button_direction: std_logic_vector (1 downto 0);
    signal keyboard_direction_p1: std_logic_vector (1 downto 0);
    signal keyboard_direction_p2: std_logic_vector (1 downto 0);
    signal direction_reg: std_logic_vector (1 downto 0):= "10";
    signal direction_reg_2: std_logic_vector (1 downto 0):= "10";
			
begin
    U1: PS2
        Port map(
            clk => clk,
            clr => clr,
            ps2d => PS2Data,
            ps2c => PS2Clk,
            ps2_out => ps2_out,
            ps2_new => ps2_valid
        );
        
     P1_keyboard_controls: PS2_direction
        Generic map (
            scan_code_00 => x"1D", -- Up
            scan_code_01 => x"1C", -- Left
            scan_code_10 => x"23", -- Right
            scan_code_11 => x"1B" -- Down
        )
        Port map ( 
            clk => clk,
            rst => clr,
            data => ps2_out,
            valid => ps2_valid,
            current_direction => direction_reg,
            new_direction => keyboard_direction_p1
    );
    
    P2_keyboard_controls: PS2_direction
        Generic map (
            scan_code_00 => x"75", -- Up
            scan_code_01 => x"6B", -- Left
            scan_code_10 => x"74", -- Right
            scan_code_11 => x"72" -- Down
        )
        Port map ( 
            clk => clk,
            rst => clr,
            data => ps2_out,
            valid => ps2_valid,
            current_direction => direction_reg_2,
            new_direction => keyboard_direction_p2
    );
    
    P1_button_controls: btn_to_direction
        Port map (
            clk => clk,
            btnU => btnU,
            btnD => btnD,
            btnL => btnL,
            btnR => btnR,
            current_direction => direction_reg,
            new_direction => button_direction
        );
    
       direction_reg <= "10" when clr ='1' else 
                        button_direction when button_en = '1' else
                        keyboard_direction_p1;
             
       direction_reg_2 <= "10" when clr ='1' else 
                        keyboard_direction_p2;
    
    direction_p1 <= direction_reg;
    direction_p2 <= direction_reg_2;
    

end Behavioral;
