library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fmsCambiarcontrasena is
Port(
           clk : in STD_LOGIC;
           modo : in STD_LOGIC;
           boton : in STD_LOGIC_VECTOR (4 downto 0);
           antigua_Con : in STD_LOGIC_VECTOR (7 downto 0);
           new_Code : out STD_LOGIC_VECTOR (7 downto 0);
           digito : out STD_LOGIC_VECTOR (1 downto 0);
           RESET : in std_logic
          );
end fmsCambiarcontrasena;

architecture Behavioral of fmsCambiarcontrasena is

 type STATES is (S0, S1, S2, S3, S4);
 signal current_state: STATES := S0;
 signal next_state: STATES;
 
 signal num : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
 signal codigo : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
 
begin

--Porceso del reset 
 state_register: process (RESET, CLK, modo)
 begin
-- Completar
       if(RESET='0' and modo='1')then
            current_state<=S0;
       elsif (rising_edge(CLK)) then
            current_state<=next_state;
       end if;
 end process;
 
 --Proceso de asignar nuevo estado
  nextstate_decod: process (boton, current_state,modo)
 begin
    if modo='1' then 
        next_state <= current_state;
        case current_state is
        when S0 =>
        if (boton(0) = '1') or ( boton(1) = '1')or ( boton(2) = '1')or ( boton(3) = '1')   then
        next_state <= S1;
        end if;
        when S1 =>
        if (boton(0) = '1') or ( boton(1) = '1')or ( boton(2) = '1')or ( boton(3) = '1')  then
        next_state <= S2;
        elsif (boton(4) = '1') then
        next_state <= S0; 
        end if;
        when S2 =>
        if (boton(0) = '1') or ( boton(1) = '1')or ( boton(2) = '1')or ( boton(3) = '1')  then
        next_state <= S3;
        elsif (boton(4) = '1') then
        next_state <= S0; 
        end if;
        when S3 =>
        if (boton(0) = '1') or ( boton(1) = '1')or ( boton(2) = '1')or ( boton(3) = '1') then
        next_state <= S4;
        elsif (boton(4) = '1') then
        next_state <= S0;       
        end if;
        when S4 =>
        if (boton(4) = '1') then
        next_state <= S0;
        end if;
        when others =>
        next_state <= S0;
        end case;  
    elsif(modo='0') then 
        next_state <= S0;   
    end if;
    
end process;


--Proceso de salidas
output_decod: process (current_state, modo, boton)
 begin
    if modo='1' then
    
      --Asignamos cada botón a un valor
        if (boton(0) = '1') then 
            num <= "00";
        elsif (boton(1) = '1') then
            num <= "01";
        elsif (boton(2) = '1') then 
            num <= "10";
        elsif (boton(3) = '1') then 
            num <= "11";
        elsif boton(4)='1' then 
            num <= "00";
        end if;
        
        case current_state is
        when S0 =>
            --Cambiar lo que pasemos, otra cosa distinta
            codigo<=(OTHERS=>'0');
        when S1 =>
            digito <= num;
            codigo <= num (1 downto 0) & codigo(5 downto 0);
        when S2 =>
            digito <= num;
            codigo <= codigo(7 downto 6) & num (1 downto 0) & codigo(3 downto 0);
        when S3 =>
            digito <= num;
            codigo <= codigo(7 downto 4) & num (1 downto 0) & codigo(1 downto 0);
        when S4 =>
            digito <= num;
            codigo <= codigo(7 downto 2) & num (1 downto 0);
        when others =>
            codigo<=(OTHERS=>'0');
        end case;
        
        new_code<=codigo;
        
     elsif (modo='0') then 
        codigo<= antigua_Con;
        new_code<=antigua_Con;    
    end if;
 end process;

end Behavioral;
