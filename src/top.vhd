library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
  PORT (
    CLK               : in  std_logic;                  -- Reloj
    boton             : in  std_logic_vector (4 downto 0);
    SWITCH            : in  std_logic;
    RESET             : in  std_logic;                  -- Señal de reset
    LEDRBG_comparador : out std_logic_vector(2 downto 0);
    LEDRBG_modo       : out std_logic_vector(2 downto 0);
    LED               : out std_logic_vector(3 downto 0);
    segment           : out std_logic_vector(6 downto 0)
  );
end top;

architecture structural of top is

    component FSM_MODE
        PORT (
        CLK        : in std_logic;
        SWITCH     : in std_logic;
        MODE       : out std_logic;
        LEDRGB_OUT :out std_logic_vector(2 downto 0)
        );
    end component;
    
    component DISPLAY
        PORT (
         CODE_IN : in  STD_LOGIC_VECTOR(7 downto 0);
         RST_N   : in  STD_LOGIC;
         CLK     : in  STD_LOGIC;
         SEGMENT : out std_logic_vector(6 downto 0);
         ANODE   : out std_logic_vector(3 downto 0)
        );
    end component;
    component fsmCambiarcontrasena
        PORT (
           clk         : in STD_LOGIC;
           modo        : in STD_LOGIC;
           boton       : in STD_LOGIC_VECTOR (4 downto 0);
           antigua_Con : in STD_LOGIC_VECTOR (7 downto 0);
           new_Code    : out STD_LOGIC_VECTOR (7 downto 0);
           digito      : out STD_LOGIC_VECTOR (1 downto 0);
           RESET       : in std_logic
        );
    end component;
    component fsmDesbloquear
        PORT ( 
           clk       : in STD_LOGIC;
           modo      : in STD_LOGIC;
           boton     : in STD_LOGIC_VECTOR (4 downto 0);
           CODE_OUT  : out STD_LOGIC_VECTOR (7 downto 0);
           LED_OUT   : out STD_LOGIC_VECTOR (3 downto 0);
           digito    : out STD_LOGIC_VECTOR (1 downto 0);
           RESET     : in std_logic
        );
    end component;       
begin

FSM_MODE_inst: FSM_MODE
    PORT MAP(
        CLK=>CLK,
        
    );

end structural;