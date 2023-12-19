library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparador is
 PORT (
     CLK      : in std_logic; -- Clock
     mode     : in std_logic; -- Selector de modo | Modo 0(Desbloquear) Modo 1(Nueva contrase�a)
     new_Code : in std_logic_vector(7 downto 0);  -- Nueva contase�a
     code_In  : in std_logic_vector(7 downto 0);  -- Comprobar contrase�a
     DONE0    : in std_logic;
     DONE1    : in std_logic; 
     led_RGB  : out std_logic_vector(2 downto 0) -- Led RGB
 );
end comparador;

architecture Behavioral of comparador is
    signal comparador : std_logic_vector(7 downto 0) := (others => '0');

begin
    process (CLK, mode,DONE1,DONE0)
    begin
        if rising_edge(CLK) then
        
            led_RGB<="000";
            
            if mode = '0' and DONE0 ='1'then                          -- MODO DESBLOQUEAR                                                       
                
                if (comparador = code_In) then  -- Comparamos la contrase�a introducida con la guardada
                    led_RGB <= "010";                   -- Led verde CORRECTO
                else 
                    led_RGB <= "100";                   -- Led rojo INCORRECTO
                end if;
            end if;    
                
            if mode = '1' and DONE1 ='1' then                          -- MODO CAMBIAR CONTRASE�A
                comparador <= new_Code;         -- Asignamos el nuevo codigo a la se�al de que lo guarda
            end if;
            
        end if;
    
    end process;

end Behavioral;
