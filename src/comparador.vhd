library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparador is
 PORT (
     CLK      : in std_logic; --Clock
     mode     : in std_logic; -- Selector de modo | Modo 0(Desbloquear) Modo 1(Nueva contraseña)
     new_Code : in std_logic_vector(7 downto 0); -- Nueva contaseña
     code_In  : in std_logic_vector(7 downto 0); -- Comprobar contraseña
     led_RGB  : out std_logic_vector(2 downto 0); -- Led RGB
     code_Out : out std_logic_vector(7 downto 0)
 );
end comparador;

architecture Behavioral of comparador is
    signal comparador : std_logic_vector(7 downto 0) := "00000000";

begin
    process (CLK, mode)
    begin
        if rising_edge(CLK) then
            if mode = '0' then
                -- Modo desbloquear activado
                if (comparador = code_In) then
                    -- Led verde CORRECTO
                    led_RGB <= "010"; 
                else 
                    led_RGB <= "100";                  
                end if;
            else if mode = '1' then
                -- Modo nueva contraseña (Cambiamos la contraseña)
                comparador <= new_Code;
                -- El comparador no hace nada 
                --led_RGB <= "011"; -- Prueba led amarillo, si funciona el cambiar contraseña
            end if;
        end if;
        end if;
        code_Out <= comparador;
    end process;

end Behavioral;
