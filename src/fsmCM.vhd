library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity fsm_mode is
    port ( 
        CLK        : in std_logic;
        SWITCH     : in std_logic;
        MODE       : out std_logic;
        LEDRGB_OUT :out std_logic_vector(2 downto 0)
    );
end fsm_mode;

architecture Behavioral of fsm_mode is
    type STATES is (DESBLOQUEO, CAMBIO_CLAVE);
    
    signal current_state: STATES := DESBLOQUEO;
    signal next_state: STATES;
    signal LEDRGB : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

begin
    state_register: process (CLK)
    begin  
       if (rising_edge(CLK)) then
            current_state<=next_state;
       end if;
    end process;
  
    nextstate_decod: process (SWITCH, current_state)
    begin
        case current_state is
            when DESBLOQUEO =>
                if SWITCH = '1' then
                    next_state <= CAMBIO_CLAVE;
                end if;
            when CAMBIO_CLAVE =>
                if SWITCH = '1' then
                    next_state <= DESBLOQUEO;
                end if;
            when others =>
                next_state <= DESBLOQUEO;
        end case;
    end process;

    output_decod: process (current_state,LEDRGB)
    begin
       -- if current_state'event then
            MODE <= '0';
            LEDRGB <= "000";
            case current_state is
                when DESBLOQUEO =>
                    MODE <= '0';
                    LEDRGB <= "101";
                when CAMBIO_CLAVE =>
                    MODE <= '1';
                    LEDRGB <= "001";
                when others =>
                    MODE <= '0';
                    LEDRGB <= "000";
            end case;
     --   end if;
        
        LEDRGB_OUT<=LEDRGB;
    end process;
end Behavioral;