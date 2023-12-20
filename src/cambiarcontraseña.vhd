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
    signal current_codigo : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal next_codigo : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
 
    signal num : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');

 
begin
        --DONE1<='0';
    --Porceso del reset 
    state_register: process (RESET, CLK, modo)
    begin
    -- Completar
       if(RESET='0' and modo='1')then
            current_state<=S0;
            current_codigo <= (others => '0');
       elsif (rising_edge(CLK)) then
            current_state<=next_state;
            current_codigo <= next_codigo;
       end if;
    end process;
 
    --Proceso de asignar nuevo estado
    nextstate_decod: process (boton, num, current_state, current_codigo, modo)
    begin
        if modo='1' then 
           next_state  <= current_state;
            next_codigo <= current_codigo;
            case current_state is
            when S0 =>
                if boton(3 downto 0) /= "0000"  then
                    next_state  <= S1;
                    next_codigo <= current_codigo(5 downto 0) & num;
                elsif (boton(4) = '1') then
                    next_state  <= S0;
                    next_codigo <= (others => '0');
                end if;
            when S1 =>
                if boton(3 downto 0) /= "0000"  then
                    next_state  <= S2;
                    next_codigo <= current_codigo(5 downto 0) & num;
                elsif (boton(4) = '1') then
                    next_state  <= S0;
                    next_codigo <= (others => '0');
                end if;
            when S2 =>
                if boton(3 downto 0) /= "0000"  then
                    next_state  <= S3;
                    next_codigo <= current_codigo(5 downto 0) & num;
                elsif (boton(4) = '1') then
                    next_state  <= S0;
                    next_codigo <= (others => '0');
                end if;
            when S3 =>
                if boton(3 downto 0) /= "0000"  then
                    next_state  <= S4;
                    next_codigo <= current_codigo(5 downto 0) & num;
                elsif (boton(4) = '1') then
                    next_state  <= S0;
                    next_codigo <= (others => '0');
                end if;
            when S4 =>
                if (boton(4) = '1') then
                    next_state  <= S0;
                    next_codigo <= (others => '0');
                end if;
            when others =>
                next_state  <= S0;
                next_codigo <= (others => '0');
            end case;   
        end if; 
end process;


    -- Codificador pulsador
    boton_encoder: process (boton)
    begin
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
    end process;
        
    --Proceso de salidas
    output_decod: process (boton, current_state, modo)
    begin
        if modo = '1' then
            case current_state is
                when S0 =>
                    --CAmbiar lo que pasemos, otra cosa distinta
                    DONE1 <= '0';
                
                when S1 =>
                    DONE1 <= '0';
  
                when S2 =>
                    DONE1 <= '0';

                when S3 =>
                    DONE1 <= '0';

                when S4 =>
                    DONE1 <= '1';

                when others =>
                    DONE1 <= '0';
            end case;        
        end if;
    end process;

    new_Code <= current_codigo;
    
end Behavioral;