library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top is
  PORT (
    CLK               : in  std_logic;                  -- Reloj
    boton             : in  std_logic_vector (4 downto 0);
    SWITCH            : in  std_logic;
    RESET             : in  std_logic;                  -- Señal de reset
    LEDRBG_comparador : out
    
    segment: out std_logic_vector(6 downto 0)
  );
end top;