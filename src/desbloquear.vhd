library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsm_Desbloquear is
    Port(
        clk : in STD_LOGIC;
        modo : in STD_LOGIC;
        boton : in STD_LOGIC_VECTOR (4 downto 0);
        CODE_OUT : out STD_LOGIC_VECTOR (7 downto 0);
        LED_OUT   : out STD_LOGIC_VECTOR (3 downto 0);
        DONE0 :out std_logic; 
        RESET : in std_logic
    );
end fsm_Desbloquear;

architecture Behavioral of fsm_Desbloquear is

    type STATES is (S0, S1, S2, S3, S4);
    signal current_state: STATES := S0;
    signal next_state: STATES;
    signal current_codigo : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal next_codigo : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
 
    signal num : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal LED : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
 
begin
    
    --Porceso del reset 
    state_register: process (RESET, CLK, modo)
    begin
        -- Completar
       if RESET = '0' and modo = '0' then
            current_state  <= S0;
            current_codigo <= (others => '0');
       elsif (rising_edge(CLK)) then
            current_state  <= next_state;
            current_codigo <= next_codigo;
       end if;
    end process;
 
    --Proceso de asignar nuevo estado
    nextstate_decod: process (boton, num, current_state, current_codigo, modo)
    begin
        if modo='0' then 
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
    output_decod: process (boton, current_state, modo, LED)
    begin
        if modo = '0' then
            case current_state is
                when S0 =>
                    --CAmbiar lo que pasemos, otra cosa distinta
                    DONE0 <= '0';
                    LED   <= "0000";
                
                when S1 =>
                    DONE0 <= '0';
                    LED   <= "0001";
  
                when S2 =>
                    DONE0 <= '0';
                    LED   <= "0011";

                when S3 =>
                    DONE0 <= '0';
                    LED   <= "0111";

                when S4 =>
                    DONE0 <= '1';
                    LED   <= "1111";
                    --CODE_OUT <= current_codigo;

                when others =>
                    DONE0 <= '0';
                    LED   <= "0000";
            end case;        
        end if;
    end process;

    CODE_OUT <= current_codigo;
    LED_OUT  <= LED;
end Behavioral;