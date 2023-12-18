library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity fsm_Cambiar_contrasena is
    Port(
        clk : in STD_LOGIC;
        modo : in STD_LOGIC;
        boton : in STD_LOGIC_VECTOR (4 downto 0);
        --antigua_Con : in STD_LOGIC_VECTOR (7 downto 0);
        new_Code : out STD_LOGIC_VECTOR (7 downto 0);
        DONE1   : out std_logic;
        RESET : in std_logic
    );
end fsm_Cambiar_contrasena;

architecture Behavioral of fsm_Cambiar_contrasena is

    type STATES is (S0, S1, S2, S3, S4);
    signal current_state: STATES := S0;
    signal next_state: STATES;
 
    signal num : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal codigo : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
 
begin
        --DONE1<='0';
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
                num <= "XX";
            end if;
            
            case current_state is
            when S0 =>
                --Cambiar lo que pasemos, otra cosa distinta
                DONE1<='0';
                codigo<=(OTHERS=>'0');
            when S1 =>
                --DONE1<='0';
                codigo <= num (1 downto 0) & codigo(5 downto 0);
            when S2 =>
                codigo <= codigo(7 downto 6) & num (1 downto 0) & codigo(3 downto 0);
            when S3 =>
                codigo <= codigo(7 downto 4) & num (1 downto 0) & codigo(1 downto 0);
            when S4 =>
                codigo <= codigo(7 downto 2) & num (1 downto 0);
                new_code<=codigo;
                DONE1<='1';
            when others =>
                codigo<=(OTHERS=>'0');
            end case;
            
            --new_code<=codigo;
         end if;   
    end process;

end Behavioral;